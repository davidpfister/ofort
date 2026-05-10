from pathlib import Path
import re
import shutil
import subprocess
import sys

import pytest

from scripts.analyze_ofort_symbols import DEFAULT_SOURCE, build_report, keyword_name_test_source


ROOT = Path(__file__).resolve().parents[1]
OFORT = ROOT / "ofort.exe"
CASES = ROOT / "tests" / "cases"
RUNNER = ROOT / "scripts" / "xofort.py"


@pytest.fixture(scope="session", autouse=True)
def build_ofort():
    result = subprocess.run(
        ["make"],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=30,
    )
    assert result.returncode == 0, result.stdout + result.stderr
    assert OFORT.exists()


def case_files():
    def has_text_expected_output(source):
        expected = source.with_suffix(".out")
        if not expected.exists():
            return False
        try:
            expected.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            return False
        return True

    return sorted(
        source for source in CASES.glob("*.f90")
        if has_text_expected_output(source)
        if source.name not in {
            "xinput_output_unit.f90",
            "xsub.f90",
            "ximplicit_none.f90",
            "xtype_change.f90",
            "xwrite_file.f90",
            "xwrite_file_alloc.f90",
            "xstream.f90",
            "xexit.f90",
            "xtyped_function.f90",
            "xtype_keyword_intrinsic.f90",
            "xrandom_print_array.f90",
            "ximplicit_default.f90",
            "xcpu_time.f90",
            "xdate_and_time.f90",
            "xtransfer.f90",
            "xsave.f90",
            "xentry_obsolescent.f90",
            "xalternate_return_obsolescent.f90",
            "xalternate_return_dummy_obsolescent.f90",
            "xallocate_already_allocated.f90",
            "ximplicit_derived_type.f90",
            "ximplicit_typing_ranges.f90",
        }
    )


def test_keywords_can_be_variable_names_like_gfortran(tmp_path):
    gfortran = shutil.which("gfortran")
    if not gfortran:
        pytest.skip("gfortran is required as the keyword-name oracle")

    keywords = build_report(DEFAULT_SOURCE)["keywords"]
    source = tmp_path / "keyword_names.f90"
    exe = tmp_path / ("keyword_names.exe" if sys.platform.startswith("win") else "keyword_names")
    source.write_text(keyword_name_test_source(keywords), encoding="utf-8")

    gfortran_compile = subprocess.run(
        [gfortran, str(source), "-o", str(exe)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=15,
    )
    assert gfortran_compile.returncode == 0, gfortran_compile.stdout + gfortran_compile.stderr

    expected = subprocess.run(
        [str(exe)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )
    assert expected.returncode == 0, expected.stdout + expected.stderr

    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stdout + result.stderr
    assert result.stderr == ""
    assert result.stdout.split() == expected.stdout.split()


def test_namelist_read_write_roundtrip(tmp_path):
    source = tmp_path / "xnamelist.f90"
    source.write_text(
        """
program test_namelist
   implicit none

   integer, parameter :: dp = kind(1.0d0)
   integer :: i, n
   real(kind=dp) :: x, y
   logical :: flag
   character(len=20) :: title
   integer :: a(3)
   real(kind=dp) :: b(2, 2)

   namelist /params/ n, x, y, flag, title, a, b

   n = 0
   x = 0.0_dp
   y = 0.0_dp
   flag = .false.
   title = "unset"
   a = 0
   b = 0.0_dp

   write(*, nml=params)

   open(unit=10, file="test_namelist.in", status="replace", action="write")
   write(10, '(a)') "&params"
   write(10, '(a)') " n = 5,"
   write(10, '(a)') " x = 1.25,"
   write(10, '(a)') " y = -3.5,"
   write(10, '(a)') " flag = .true.,"
   write(10, '(a)') " title = 'compiler test',"
   write(10, '(a)') " a = 10, 20, 30,"
   write(10, '(a)') " b = 1.0, 2.0, 3.0, 4.0"
   write(10, '(a)') "/"
   close(10)

   open(unit=11, file="test_namelist.in", status="old", action="read")
   read(11, nml=params)
   close(11)

   print *, "values after reading namelist"
   print *, "n     =", n
   print *, "x     =", x
   print *, "y     =", y
   print *, "flag  =", flag
   print *, "title =", trim(title)
   print *, "a     =", a
   print *, "b     ="
   do i = 1, 2
      print *, b(i, :)
   end do

   write(*, nml=params)
end program test_namelist
""",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=tmp_path,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stdout + result.stderr
    assert result.stderr == ""
    out = result.stdout
    assert out.count("&params") == 2
    assert "values after reading namelist" in out
    assert "n     = 5" in out
    assert "x     = 1.25" in out
    assert "y     = -3.5" in out
    assert "flag  = T" in out
    assert "title = compiler test" in out
    assert "a     = 10 20 30" in out
    assert "1 3" in out
    assert "2 4" in out
    assert " title = \"compiler test       \"," in out


def test_namelist_group_name_imported_from_module(tmp_path):
    source = tmp_path / "xnamelist_module.f90"
    source.write_text(
        """
module mod0
implicit none
real :: a, b
namelist /aa/ a, b
end module mod0

use mod0
implicit none
a = 1.0
b = 2.0
write(6, aa)
end
""",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=tmp_path,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stdout + result.stderr
    assert result.stderr == ""
    assert "&aa" in result.stdout
    assert " a = 1" in result.stdout
    assert " b = 2" in result.stdout


def test_namelist_group_name_use_rename(tmp_path):
    source = tmp_path / "xnamelist_rename.f90"
    source.write_text(
        """
module mod0
implicit none
real :: a, b
namelist /aa/ a, b
end module mod0

module mod1
use mod0, xxx => aa
end module mod1

use mod1
implicit none
a = 3.0
b = 4.0
write(6, xxx)
end
""",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=tmp_path,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stdout + result.stderr
    assert result.stderr == ""
    assert "&xxx" in result.stdout
    assert " a = 3" in result.stdout
    assert " b = 4" in result.stdout


def test_extends_inherits_fields_and_dispatches_dynamically(tmp_path):
    source = tmp_path / "xextends_min.f90"
    source.write_text(
        """
module shape_mod
implicit none

type :: shape
   character(len=20) :: name = "shape"
contains
   procedure :: describe => describe_shape
   procedure :: area => area_shape
end type shape

type, extends(shape) :: circle
   real :: radius = 0.0
contains
   procedure :: describe => describe_circle
   procedure :: area => area_circle
end type circle

contains

subroutine describe_shape(this)
   class(shape), intent(in) :: this
   print *, "shape", trim(this%name)
end subroutine describe_shape

function area_shape(this) result(y)
   class(shape), intent(in) :: this
   real :: y
   y = 0.0
end function area_shape

subroutine describe_circle(this)
   class(circle), intent(in) :: this
   print *, "circle", trim(this%name), this%radius
end subroutine describe_circle

function area_circle(this) result(y)
   class(circle), intent(in) :: this
   real :: y
   y = this%radius * this%radius
end function area_circle

subroutine print_shape_info(s)
   class(shape), intent(in) :: s
   call s%describe()
   print *, "area", s%area()
end subroutine print_shape_info

end module shape_mod

program main
use shape_mod
implicit none

type(shape) :: s
type(circle) :: c

s%name = "plain"
c%name = "unit"
c%radius = 2.0

call s%describe()
print *, s%area()
call c%describe()
print *, c%area()
call print_shape_info(s)
call print_shape_info(c)
end program main
""",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=tmp_path,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stdout + result.stderr
    assert result.stderr == ""
    assert result.stdout.split() == [
        "shape", "plain",
        "0",
        "circle", "unit", "2",
        "4",
        "shape", "plain",
        "area", "0",
        "circle", "unit", "2",
        "area", "4",
    ]


def test_check_registers_bare_main_contained_functions(tmp_path):
    source = tmp_path / "contained_function_check.f90"
    source.write_text(
        """
implicit none
integer :: n
n = f(2)
contains
integer function f(x)
   integer, intent(in) :: x
   f = x
end function
end
""",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--check", str(source)],
        cwd=tmp_path,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stdout + result.stderr
    assert result.stdout == "ofort check passed\n"
    assert result.stderr == ""


def test_recursive_allocatable_derived_component_is_unallocated_by_default(tmp_path):
    source = tmp_path / "recursive_alloc_component.f90"
    source.write_text(
        """
implicit none
type node
   real :: x = 1.0
   type(node), allocatable :: next
end type
type wrapper
   type(node) :: first
end type
type(wrapper) :: w
print *, w%first%x
end
""",
        encoding="utf-8",
    )

    check = subprocess.run(
        [str(OFORT), "--check", str(source)],
        cwd=tmp_path,
        text=True,
        capture_output=True,
        timeout=5,
    )
    run = subprocess.run(
        [str(OFORT), str(source)],
        cwd=tmp_path,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert check.returncode == 0, check.stdout + check.stderr
    assert check.stdout == "ofort check passed\n"
    assert check.stderr == ""
    assert run.returncode == 0, run.stdout + run.stderr
    assert run.stdout.strip() == "1"
    assert run.stderr == ""


@pytest.mark.parametrize("source", case_files(), ids=lambda p: p.stem)
def test_case_stdout(source):
    expected = source.with_suffix(".out").read_text(encoding="utf-8")
    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert result.stdout == expected


def test_implicit_integer_real_assignment_warns_but_runs():
    source = CASES / "ximplicit_typing_ranges.f90"
    expected = source.with_suffix(".out").read_text(encoding="utf-8")
    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout == expected
    assert "warning: assigning REAL to INTEGER variable 'i' truncates toward zero" in result.stderr
    assert "line 3: i = 2.8" in result.stderr


def test_entry_statement_is_reported_obsolescent():
    source = CASES / "xentry_obsolescent.f90"
    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode != 0
    expected = source.with_suffix(".out").read_text(encoding="utf-8").strip()
    assert expected in result.stderr


def test_alternate_return_is_reported_obsolescent():
    source = CASES / "xalternate_return_obsolescent.f90"
    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode != 0
    expected = source.with_suffix(".out").read_text(encoding="utf-8").strip()
    assert expected in result.stderr


def test_alternate_return_dummy_is_reported_obsolescent():
    source = CASES / "xalternate_return_dummy_obsolescent.f90"
    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode != 0
    expected = source.with_suffix(".out").read_text(encoding="utf-8").strip()
    assert expected in result.stderr


def test_implicit_derived_type_warns_but_runs():
    source = CASES / "ximplicit_derived_type.f90"
    expected = source.with_suffix(".out").read_text(encoding="utf-8")
    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout == expected
    assert "warning: derived-type implicit typing is legal but discouraged; prefer explicit declarations" in result.stderr
    assert "line 4: implicit type(t) (a-b)" in result.stderr


def test_allocate_rejects_already_allocated_variable():
    source = CASES / "xallocate_already_allocated.f90"
    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode != 0
    expected = source.with_suffix(".out").read_text(encoding="utf-8").strip()
    assert expected in result.stderr
    assert "line 17: allocate (dates(4))" in result.stderr


def test_parser_expected_token_errors_are_readable(tmp_path):
    source = tmp_path / "xbad_syntax.f90"
    source.write_text("integer : i\n", encoding="utf-8")
    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode != 0
    assert "Expected token type" not in result.stderr
    assert "Syntax error at line 1: expected identifier but found ':'" in result.stderr
    assert "line 1: integer : i" in result.stderr


def test_check_reports_undeclared_identifier_with_implicit_none(tmp_path):
    source = tmp_path / "xcheck_implicit_none.f90"
    source.write_text(
        "program main\n"
        "  implicit none\n"
        "  integer :: n\n"
        "  n = 2**5\n"
        "  print *, m\n"
        "end program main\n",
        encoding="utf-8",
    )
    result = subprocess.run(
        [str(OFORT), "--check", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode != 0
    assert "Undefined variable 'm' at line 5" in result.stderr
    assert "line 5:   print *, m" in result.stderr


def test_trace_assign_reports_assignment_values(tmp_path):
    source = tmp_path / "xtrace_assign.f90"
    source.write_text(
        "integer :: x\n"
        "x = 1\n"
        "x = x + 2\n"
        "print *, x\n"
        "end\n",
        encoding="utf-8",
    )
    result = subprocess.run(
        [str(OFORT), "--trace-assign", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout == "3\n"
    assert result.stderr == "1\n3\n"


def test_xsub_random_statistics():
    source = CASES / "xsub.f90"
    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=10,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""

    parts = result.stdout.split()
    assert len(parts) == 3
    n = int(parts[0])
    mean = float(parts[1])
    sd = float(parts[2])

    assert n == 100
    assert 0.0 <= mean < 1.0
    assert 0.0 <= sd < 0.6


def test_cpu_time_runs_and_reports_elapsed_time():
    source = CASES / "xcpu_time.f90"
    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    lines = result.stdout.splitlines()
    assert lines[:2] == [
        "cpu_time returns CPU time in seconds.",
        "",
    ]
    assert re.match(r"^result s = \d+(?:\.\d+)?(?:e[+-]?\d+)?$", lines[2])
    match = re.match(r"^CPU time = ([0-9]+(?:\.[0-9]+)?(?:e[+-]?[0-9]+)?) seconds$", lines[3])
    assert match
    assert float(match.group(1)) >= 0.0


def test_date_and_time_reports_clock_fields():
    source = CASES / "xdate_and_time.f90"
    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    lines = result.stdout.splitlines()
    assert "date only:" in lines
    assert "time only:" in lines
    assert "zone only:" in lines
    assert "values only:" in lines
    assert "all arguments:" in lines
    date_match = re.search(r"(?m)^date =  (\d{8})$", result.stdout)
    time_match = re.search(r"(?m)^time =  (\d{6}\.\d{3})$", result.stdout)
    zone_match = re.search(r"(?m)^zone =  ([+-]\d{4})$", result.stdout)
    values_match = re.search(
        r"(?m)^values =  (\d{4}) (\d{1,2}) (\d{1,2}) ([+-]?\d+) "
        r"(\d{1,2}) (\d{1,2}) (\d{1,2}) (\d{1,3})$",
        result.stdout,
    )
    formatted_match = re.search(
        r"(?m)^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})\.(\d{3}) ([+-]\d{4})$",
        result.stdout,
    )
    assert date_match
    assert time_match
    assert zone_match
    assert values_match
    assert formatted_match
    year, month, day, offset, hour, minute, second, millisecond = values_match.groups()
    assert date_match.group(1) == f"{year}{int(month):02d}{int(day):02d}"
    assert time_match.group(1) == f"{int(hour):02d}{int(minute):02d}{int(second):02d}.{int(millisecond):03d}"
    assert zone_match.group(1) == formatted_match.group(8)
    assert formatted_match.groups()[:7] == (
        year,
        f"{int(month):02d}",
        f"{int(day):02d}",
        f"{int(hour):02d}",
        f"{int(minute):02d}",
        f"{int(second):02d}",
        f"{int(millisecond):03d}",
    )
    assert -1440 <= int(offset) <= 1440


def test_transfer_reinterprets_basic_values():
    source = CASES / "xtransfer.f90"
    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert "integer to real:" in result.stdout
    assert "real to integer:" in result.stdout
    assert "character to integer:" in result.stdout
    assert "array result using size argument:" in result.stdout

    int_to_real = re.findall(r"ia\(i\) = (\d+)  transfer -> real = ([0-9.e+-]+)", result.stdout)
    assert [int(i) for i, _ in int_to_real] == [1, 2, 3, 4]
    assert [pytest.approx(float(x), rel=1e-6) for _, x in int_to_real] == [
        1.401298e-45,
        2.802597e-45,
        4.203895e-45,
        5.605194e-45,
    ]

    real_to_int = re.findall(r"ra\(i\) = (\d+)  transfer -> integer = (\d+)", result.stdout)
    assert [(int(r), int(i)) for r, i in real_to_int] == [
        (1, 1065353216),
        (2, 1073741824),
        (3, 1077936128),
        (4, 1082130432),
    ]

    assert "s = ABCD  transfer(s,0) = 1145258561" in result.stdout
    assert "transfer(ia, 0.0, size=2) = 1.401298e-45 2.802597e-45" in result.stdout
    assert "transfer(ia, 0.0, size=1) = 1.401298e-45" in result.stdout


def test_formatted_print_expands_random_array():
    source = CASES / "xrandom_print_array.f90"
    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    parts = result.stdout.split()
    assert len(parts) == 2
    assert all(0.0 <= float(part) < 1.0 for part in parts)


def test_implicit_none_rejects_undeclared_variable():
    source = CASES / "ximplicit_none.f90"
    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode != 0
    assert result.stdout == ""
    assert "Variable 'i' has no implicit type" in result.stderr
    assert "line 2: i = 2" in result.stderr


def test_implicit_typing_is_default():
    source = CASES / "ximplicit_default.f90"
    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout.split() == ["2"]
    assert result.stderr == ""


def test_no_implicit_typing_option_rejects_undeclared_variable():
    source = CASES / "ximplicit_default.f90"
    result = subprocess.run(
        [str(OFORT), "--no-implicit-typing", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode != 0
    assert result.stdout == ""
    assert "Variable 'i' has no implicit type" in result.stderr


def test_implicit_typing_option_allows_legacy_default():
    source = CASES / "ximplicit_default.f90"
    result = subprocess.run(
        [str(OFORT), "--implicit-typing", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout.split() == ["2"]
    assert result.stderr == ""


def test_command_arguments_from_file_mode(tmp_path):
    source = tmp_path / "xargs.f90"
    source.write_text(
        "program xargs\n"
        "implicit none\n"
        "integer :: n, length, status\n"
        "character(len=8) :: arg\n"
        "n = command_argument_count()\n"
        "print *, n\n"
        "call get_command_argument(1, arg, length, status)\n"
        "print *, trim(arg), length, status\n"
        "call get_command_argument(2, arg, length, status)\n"
        "print *, trim(arg), length, status\n"
        "end program xargs\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), str(source), "--", "alpha", "longer_than_8"],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert result.stdout.splitlines() == [
        "2",
        "alpha 5 0",
        "longer_t 13 -1",
    ]


def test_getarg_extension_from_file_mode(tmp_path):
    source = tmp_path / "xgetarg.f90"
    source.write_text(
        "program xgetarg\n"
        "implicit none\n"
        "character(len=8) :: arg\n"
        "call getarg(1, arg)\n"
        "print *, trim(arg)\n"
        "end program xgetarg\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), str(source), "--", "alpha"],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout.strip() == "alpha"
    assert "warning: nonstandard GETARG extension; prefer GET_COMMAND_ARGUMENT" in result.stderr


def test_w_option_suppresses_getarg_warning(tmp_path):
    source = tmp_path / "xgetarg.f90"
    source.write_text(
        "program xgetarg\n"
        "implicit none\n"
        "character(len=8) :: arg\n"
        "call getarg(1, arg)\n"
        "print *, trim(arg)\n"
        "end program xgetarg\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "-w", str(source), "--", "alpha"],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout.strip() == "alpha"
    assert result.stderr == ""


def test_multiple_source_files_are_concatenated(tmp_path):
    first = tmp_path / "part1.f90"
    second = tmp_path / "part2.f90"
    first.write_text(
        "program xmulti\n"
        "implicit none\n"
        "integer :: i\n"
        "i = 6\n",
        encoding="utf-8",
    )
    second.write_text(
        "print *, i * 7\n"
        "end program xmulti\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), str(first), str(second)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert result.stdout.split() == ["42"]


def test_extensionless_source_argument_tries_f90(tmp_path):
    source = tmp_path / "xshortcut.f90"
    source.write_text(
        "program xshortcut\n"
        "  print *, 42\n"
        "end program xshortcut\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), str(tmp_path / "xshortcut")],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout == "42\n"


def test_existing_extensionless_source_argument_wins_over_f90(tmp_path):
    source = tmp_path / "xshortcut"
    source_f90 = tmp_path / "xshortcut.f90"
    source.write_text(
        "program xshortcut\n"
        "  print *, 7\n"
        "end program xshortcut\n",
        encoding="utf-8",
    )
    source_f90.write_text(
        "program xshortcut\n"
        "  print *, 99\n"
        "end program xshortcut\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout == "7\n"


def test_manifest_source_files_are_concatenated(tmp_path):
    first = tmp_path / "part1.f90"
    second = tmp_path / "part2.f90"
    manifest = tmp_path / "files.txt"
    first.write_text(
        "program xmanifest\n"
        "implicit none\n"
        "integer :: i\n"
        "i = 7\n",
        encoding="utf-8",
    )
    second.write_text(
        "print *, i * 6\n"
        "end program xmanifest\n",
        encoding="utf-8",
    )
    manifest.write_text(
        "# relative paths are resolved from the manifest directory\n"
        "part1.f90\n"
        "\n"
        "! another comment\n"
        "part2.f90\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), f"@{manifest}"],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert result.stdout.split() == ["42"]


def test_manifest_each_mode_runs_files_separately(tmp_path):
    first = tmp_path / "a.f90"
    second = tmp_path / "b.f90"
    manifest = tmp_path / "files.txt"
    first.write_text("print *, 11\n", encoding="utf-8")
    second.write_text("print *, 22\n", encoding="utf-8")
    manifest.write_text("a.f90\nb.f90\n", encoding="utf-8")

    result = subprocess.run(
        [str(OFORT), "--each", f"@{manifest}"],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert "a.f90" in result.stdout
    assert "b.f90" in result.stdout
    assert "11" in result.stdout.split()
    assert "22" in result.stdout.split()


def test_manifest_errors_include_source_file_name(tmp_path):
    first = tmp_path / "part1.f90"
    second = tmp_path / "part2.f90"
    manifest = tmp_path / "files.txt"
    first.write_text(
        "program xmanifest_error\n"
        "implicit none\n",
        encoding="utf-8",
    )
    second.write_text(
        "print *, 1 .bad. 2\n"
        "end program xmanifest_error\n",
        encoding="utf-8",
    )
    manifest.write_text("part1.f90\npart2.f90\n", encoding="utf-8")

    result = subprocess.run(
        [str(OFORT), f"@{manifest}"],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 1
    assert str(second) in result.stderr
    assert f"{second}:1:" in result.stderr
    assert "line 3:" in result.stderr


def test_private_module_names_are_not_imported(tmp_path):
    source = tmp_path / "xprivate_hidden.f90"
    source.write_text(
        "module m\n"
        "implicit none\n"
        "private\n"
        "public :: pi\n"
        "real :: pi = 3.14\n"
        "real :: hidden = 2.0\n"
        "end module m\n"
        "program main\n"
        "use m\n"
        "implicit none\n"
        "print *, hidden\n"
        "end program main\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode != 0
    assert result.stdout == ""
    assert "Undefined variable 'hidden'" in result.stderr


def test_protected_module_variable_cannot_be_assigned_after_use(tmp_path):
    source = tmp_path / "xprotected_assign.f90"
    source.write_text(
        "module m\n"
        "implicit none\n"
        "real, protected :: pi = 3.14\n"
        "end module m\n"
        "program main\n"
        "use m\n"
        "implicit none\n"
        "pi = 4.0\n"
        "print *, pi\n"
        "end program main\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode != 0
    assert result.stdout == ""
    assert "Cannot assign to PROTECTED variable 'pi'" in result.stderr


def test_save_warns_for_implicit_save_local():
    source = CASES / "xsave.f90"
    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout == source.with_suffix(".out").read_text(encoding="utf-8")
    assert "warning: local variable 'mcall' has implicit SAVE due to initialization" in result.stderr
    assert "integer :: mcall = 0" in result.stderr
    assert "ncall" not in result.stderr


def test_w_option_suppresses_warnings():
    source = CASES / "xsave.f90"
    result = subprocess.run(
        [str(OFORT), "-w", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout == source.with_suffix(".out").read_text(encoding="utf-8")
    assert result.stderr == ""


def test_implicit_external_unit_warns(tmp_path):
    source = tmp_path / "ximplicit_unit.f90"
    source.write_text(
        "integer :: i, j\n"
        "write(12,*) 70, 80\n"
        "rewind 12\n"
        "read(12,*) i, j\n"
        "print *, i, j\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=tmp_path,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout == "70 80\n"
    assert "warning: implicit external unit 12 uses default file 'fort.12'; prefer OPEN with FILE=" in result.stderr
    assert (tmp_path / "fort.12").read_text(encoding="utf-8") == "70 80\n"


def test_w_option_suppresses_implicit_external_unit_warning(tmp_path):
    source = tmp_path / "ximplicit_unit.f90"
    source.write_text(
        "integer :: i, j\n"
        "write(12,*) 70, 80\n"
        "rewind 12\n"
        "read(12,*) i, j\n"
        "print *, i, j\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "-w", str(source)],
        cwd=tmp_path,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout == "70 80\n"
    assert result.stderr == ""


def test_input_unit_reads_from_stdin(tmp_path):
    source = CASES / "xinput_output_unit.f90"

    result = subprocess.run(
        [str(OFORT), str(source)],
        input="Alice\n33\n",
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert result.stdout == source.with_suffix(".out").read_text(encoding="utf-8")


def test_fast_option_suppresses_warnings_and_preserves_output():
    source = CASES / "xsave.f90"
    result = subprocess.run(
        [str(OFORT), "--fast", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout == source.with_suffix(".out").read_text(encoding="utf-8")
    assert result.stderr == ""


def test_real_star_8_extension_warns_and_runs(tmp_path):
    source = tmp_path / "xreal_star_8.f90"
    source.write_text(
        "real*8 :: x\n"
        "x = 1.25d0\n"
        "print *, kind(x), x\n",
        encoding="utf-8",
    )
    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout == "8 1.25\n"
    assert "warning: nonstandard REAL*8 treated as REAL(KIND=8) extension" in result.stderr


def test_w_option_suppresses_real_star_8_warning(tmp_path):
    source = tmp_path / "xreal_star_8.f90"
    source.write_text(
        "real*8 :: x\n"
        "x = 1.25d0\n"
        "print *, kind(x), x\n",
        encoding="utf-8",
    )
    result = subprocess.run(
        [str(OFORT), "-w", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout == "8 1.25\n"
    assert result.stderr == ""


def test_write_extra_comma_warns_and_runs(tmp_path):
    source = tmp_path / "xwrite_comma.f90"
    source.write_text(
        'write (*,*), "hello"\n'
        "end\n",
        encoding="utf-8",
    )
    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout == "hello\n"
    assert "warning: nonstandard comma between WRITE control list and I/O list" in result.stderr


def test_write_extra_comma_rejected_by_f2023(tmp_path):
    source = tmp_path / "xwrite_comma.f90"
    source.write_text(
        'write (*,*), "hello"\n'
        "end\n",
        encoding="utf-8",
    )
    result = subprocess.run(
        [str(OFORT), "--std=f2023", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode != 0
    assert result.stdout == ""
    assert "nonstandard comma between WRITE control list and I/O list is not allowed with --std=f2023" in result.stderr


def test_fast_option_preserves_counted_do_loop_result():
    source = CASES / "xlarge_do_loop.f90"
    result = subprocess.run(
        [str(OFORT), "--fast", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout == source.with_suffix(".out").read_text(encoding="utf-8")
    assert result.stderr == ""


def test_fast_option_handles_initialized_arrays():
    source = CASES / "xarray_init.f90"
    result = subprocess.run(
        [str(OFORT), "--fast", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout == source.with_suffix(".out").read_text(encoding="utf-8")
    assert result.stderr == ""


def test_fast_option_handles_rank2_array_expressions():
    source = CASES / "xfast_rank2_array_expr.f90"
    result = subprocess.run(
        [str(OFORT), "--fast", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout == source.with_suffix(".out").read_text(encoding="utf-8")
    assert result.stderr == ""


def test_fast_option_aliases_array_dummy_arguments():
    source = CASES / "xfast_array_dummy_alias.f90"
    result = subprocess.run(
        [str(OFORT), "--fast", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout == source.with_suffix(".out").read_text(encoding="utf-8")
    assert result.stderr == ""


def test_fast_option_reuses_local_array_storage_safely():
    source = CASES / "xfast_local_array_reuse.f90"
    result = subprocess.run(
        [str(OFORT), "--fast", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout == source.with_suffix(".out").read_text(encoding="utf-8")
    assert result.stderr == ""


def test_fast_option_handles_nested_numeric_do_loops():
    source = CASES / "xfast_numeric_do_loop.f90"
    result = subprocess.run(
        [str(OFORT), "--fast", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout == source.with_suffix(".out").read_text(encoding="utf-8")
    assert result.stderr == ""


def test_fast_option_handles_array_random_number_and_sum(tmp_path):
    source = tmp_path / "xfast_array.f90"
    source.write_text(
        "integer, parameter :: n = 1000\n"
        "real :: x(n)\n"
        "call random_number(x)\n"
        "print *, sum(x) / size(x)\n"
        "end\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--fast", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    mean = float(result.stdout.strip())
    assert 0.0 <= mean <= 1.0


def test_fast_random_number_advances_state(tmp_path):
    source = tmp_path / "xfast_random_state.f90"
    source.write_text(
        "real :: x\n"
        "call random_number(x)\n"
        "print *, x\n"
        "call random_number(x)\n"
        "print *, x\n"
        "end\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--fast", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    values = [float(line) for line in result.stdout.splitlines()]
    assert len(values) == 2
    assert all(0.0 <= value < 1.0 for value in values)
    assert values[0] != values[1]


def test_fast_packed_array_reads_default_numeric_element(tmp_path):
    source = tmp_path / "xfast_packed_default.f90"
    source.write_text(
        "real :: x(3)\n"
        "print *, kind(x(1)), x(1)\n"
        "end\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--fast", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert result.stdout == "4 0\n"


def test_fast_packed_array_power_can_be_summed(tmp_path):
    source = tmp_path / "xfast_packed_power_sum.f90"
    source.write_text(
        "real :: x(3)\n"
        "x(1) = 1.0\n"
        "x(2) = 2.0\n"
        "x(3) = 3.0\n"
        "print *, sum(x), sum(x**2)\n"
        "end\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--fast", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert result.stdout == "6 14\n"


def test_fast_scalar_numeric_update(tmp_path):
    source = tmp_path / "xfast_scalar_update.f90"
    source.write_text(
        "real :: x, xsum\n"
        "integer :: i\n"
        "x = 0.25\n"
        "xsum = 0.0\n"
        "do i = 1, 4\n"
        "  xsum = xsum + x\n"
        "end do\n"
        "print *, xsum\n"
        "end\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--fast", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert result.stdout == "1\n"


def test_fast_random_sum_loop_pattern(tmp_path):
    source = tmp_path / "xfast_random_sum_loop.f90"
    source.write_text(
        "integer, parameter :: n = 1000\n"
        "real :: x, xsum\n"
        "integer :: i\n"
        "xsum = 0.0\n"
        "do i = 1, n\n"
        "  call random_number(x)\n"
        "  xsum = xsum + x\n"
        "end do\n"
        "print *, i, xsum/n\n"
        "end\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--fast", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    fields = result.stdout.split()
    assert int(fields[0]) == 1001
    assert 0.0 <= float(fields[1]) < 1.0


def test_time_option_reports_execution_time_without_changing_stdout():
    source = CASES / "xtry.f90"
    result = subprocess.run(
        [str(OFORT), "--time", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout == source.with_suffix(".out").read_text(encoding="utf-8")
    assert re.search(r"(?m)^time: \d+\.\d{6} s$", result.stderr)


def test_profile_lines_reports_statement_times(tmp_path):
    source = tmp_path / "xprofile.f90"
    source.write_text(
        "integer :: i\n"
        "i = 2\n"
        "print *, i**5\n"
        "end\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--profile-lines", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout == "32\n"
    assert "line profile:" in result.stderr
    assert re.search(r"(?m)^\s*2\s+1\s+\d+\.\d{6}\s+i = 2$", result.stderr)
    assert re.search(r"(?m)^\s*3\s+1\s+\d+\.\d{6}\s+print \*, i\*\*5$", result.stderr)


def test_time_option_reports_check_time_without_changing_stdout(tmp_path):
    source = tmp_path / "xcheck_time.f90"
    source.write_text(
        "program xcheck_time\n"
        "print *, 12345\n"
        "end program xcheck_time\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--time", "--check", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout == "ofort check passed\n"
    assert re.search(r"(?m)^time: \d+\.\d{6} s$", result.stderr)


def assert_time_detail(stderr):
    assert re.search(
        r"(?m)^time:\n"
        r"  setup:    \d+\.\d{6} s\n"
        r"  lex:      \d+\.\d{6} s\n"
        r"  parse:    \d+\.\d{6} s\n"
        r"  register: \d+\.\d{6} s\n"
        r"  execute:  \d+\.\d{6} s\n"
        r"  total:    \d+\.\d{6} s$",
        stderr,
    )


def test_time_detail_option_reports_execution_breakdown_without_changing_stdout():
    source = CASES / "xtry.f90"
    result = subprocess.run(
        [str(OFORT), "--time-detail", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout == source.with_suffix(".out").read_text(encoding="utf-8")
    assert_time_detail(result.stderr)


def test_time_detail_option_reports_check_breakdown_without_changing_stdout(tmp_path):
    source = tmp_path / "xcheck_time_detail.f90"
    source.write_text(
        "program xcheck_time_detail\n"
        "print *, 12345\n"
        "end program xcheck_time_detail\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--time-detail", "--check", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout == "ofort check passed\n"
    assert_time_detail(result.stderr)


def test_repl_warns_when_implicit_save_line_is_entered(tmp_path):
    source = tmp_path / "empty.f90"
    source.write_text("", encoding="utf-8")

    result = subprocess.run(
        [str(OFORT), "--load", str(source)],
        cwd=ROOT,
        input="subroutine s()\ninteger :: n = 0\n.clear\n.quit\n",
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert "warning: local variable 'n' has implicit SAVE due to initialization" in result.stderr


def test_w_option_suppresses_repl_implicit_save_warning(tmp_path):
    source = tmp_path / "empty.f90"
    source.write_text("", encoding="utf-8")

    result = subprocess.run(
        [str(OFORT), "-w", "--load", str(source)],
        cwd=ROOT,
        input="subroutine s()\ninteger :: n = 0\n.clear\n.quit\n",
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""


def test_repl_run_repeats_with_command_arguments(tmp_path):
    source = tmp_path / "xrun.f90"
    source.write_text(
        "program xrun\n"
        "implicit none\n"
        "print *, command_argument_count()\n"
        "end program xrun\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--load", str(source)],
        cwd=ROOT,
        input=".run 2 -- aa bb\n.runq 1 -- cc\n",
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    numeric_lines = re.findall(r"(?m)^(?:ofort>\s*)?([0-9]+)$", result.stdout)
    assert numeric_lines == ["2", "2", "1"]


def test_repl_time_repeats_and_prints_summary(tmp_path):
    source = tmp_path / "xtime.f90"
    source.write_text(
        "program xtime\n"
        "print *, 123\n"
        "end program xtime\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--load", str(source)],
        cwd=ROOT,
        input=".time 2\n.clear\n.quit\n",
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    numeric_lines = re.findall(r"(?m)^(?:ofort>\s*)?(123)$", result.stdout)
    assert numeric_lines == ["123", "123"]
    assert re.search(r"(?m)^\s+total\s+avg\s+sd\s+min\s+max$", result.stdout)
    assert re.search(
        r"(?m)^\s*\d+\.\d{6}\s+\d+\.\d{6}\s+\d+\.\d{6}\s+\d+\.\d{6}\s+\d+\.\d{6} s$",
        result.stdout,
    )


def test_repl_time_single_run_prints_only_total(tmp_path):
    source = tmp_path / "xtime1.f90"
    source.write_text(
        "program xtime1\n"
        "print *, 456\n"
        "end program xtime1\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--load", str(source)],
        cwd=ROOT,
        input=".time\n.clear\n.quit\n",
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert re.search(r"(?m)^(?:ofort>\s*)?456$", result.stdout)
    assert re.search(r"(?m)^\s+total$", result.stdout)
    assert re.search(r"(?m)^\s*\d+\.\d{6} s$", result.stdout)
    assert not re.search(r"(?m)^\s+total\s+avg\s+sd\s+min\s+max$", result.stdout)


def test_repl_vars_lists_all_and_selected_values(tmp_path):
    source = tmp_path / "xvars.f90"
    source.write_text("", encoding="utf-8")

    result = subprocess.run(
        [str(OFORT), "--load", str(source)],
        cwd=ROOT,
        input=(
            "integer :: i\n"
            "real :: x\n"
            "i = 2\n"
            "x = 3.5\n"
            ".vars\n"
            ".vars i x missing\n"
            ".clear\n"
            ".quit\n"
        ),
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert result.stdout.count("i = 2") == 2
    assert result.stdout.count("x = 3.5") == 2
    assert "missing: undefined" in result.stdout


def test_repl_info_lists_declaration_style_details(tmp_path):
    source = tmp_path / "xinfo.f90"
    source.write_text("", encoding="utf-8")

    result = subprocess.run(
        [str(OFORT), "--load", str(source)],
        cwd=ROOT,
        input=(
            "integer :: i\n"
            "real :: x(5)\n"
            "i = 2\n"
            "x = [1,2,3,4,5]\n"
            ".info\n"
            ".info x i missing\n"
            ".clear\n"
            ".quit\n"
        ),
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert result.stdout.count("integer i: 2") == 2
    assert result.stdout.count("real x(5): 1 2 3 4 5") == 2
    assert "missing: undefined" in result.stdout


def test_repl_shapes_lists_array_shapes(tmp_path):
    source = tmp_path / "xshapes.f90"
    source.write_text("", encoding="utf-8")

    result = subprocess.run(
        [str(OFORT), "--load", str(source)],
        cwd=ROOT,
        input=(
            "integer :: i\n"
            "real :: x(5)\n"
            "real :: y(3,2)\n"
            "i = 2\n"
            "x = [1,2,3,4,5]\n"
            "y = [1,2,3,4,5,6]\n"
            ".shapes\n"
            ".shapes x y i missing\n"
            ".clear\n"
            ".quit\n"
        ),
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert result.stdout.count("x: 5") == 2
    assert result.stdout.count("y: 3 2") == 2
    assert "i: scalar" in result.stdout
    assert "missing: undefined" in result.stdout


def test_repl_sizes_lists_array_sizes(tmp_path):
    source = tmp_path / "xsizes.f90"
    source.write_text("", encoding="utf-8")

    result = subprocess.run(
        [str(OFORT), "--load", str(source)],
        cwd=ROOT,
        input=(
            "integer :: i\n"
            "real :: x(5)\n"
            "real :: y(3,2)\n"
            "i = 2\n"
            "x = [1,2,3,4,5]\n"
            "y = [1,2,3,4,5,6]\n"
            ".sizes\n"
            ".sizes x y i missing\n"
            ".clear\n"
            ".quit\n"
        ),
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert result.stdout.count("x: 5") == 2
    assert result.stdout.count("y: 6") == 2
    assert "i: scalar" in result.stdout
    assert "missing: undefined" in result.stdout


def test_repl_stats_lists_grouped_array_tables(tmp_path):
    source = tmp_path / "xstats.f90"
    source.write_text("", encoding="utf-8")

    result = subprocess.run(
        [str(OFORT), "--load", str(source)],
        cwd=ROOT,
        input=(
            "integer :: i\n"
            "integer :: ia(5)\n"
            "real :: x(5)\n"
            "i = 2\n"
            "ia = [1,2,3,4,5]\n"
            "x = [2,4,6,8,10]\n"
            ".stats\n"
            ".stats x ia i missing\n"
            ".clear\n"
            ".quit\n"
        ),
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert result.stdout.count("integer arrays") == 2
    assert result.stdout.count("real arrays") == 2
    assert result.stdout.count("name                 size") == 4
    assert re.search(r"(?m)^ia\s+5\s+1\s+5\s+3\s+1\.581139\s+1\s+5$", result.stdout)
    assert re.search(r"(?m)^x\s+5\s+2\s+10\s+6\s+3\.162278\s+2\s+10$", result.stdout)
    assert "i: scalar" in result.stdout
    assert "missing: undefined" in result.stdout


def test_repl_del_deletes_lines_and_ranges(tmp_path):
    source = tmp_path / "xdel.f90"
    source.write_text(
        "program xdel\n"
        "integer :: i\n"
        "i = 1\n"
        "print *, i\n"
        "i = 2\n"
        "print *, i\n"
        "end program xdel\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--load", str(source)],
        cwd=ROOT,
        input=".del 5\n.del 3:4\n.list\n.clear\n.quit\n",
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert "   1  program xdel\n" in result.stdout
    assert "   2    integer :: i\n" in result.stdout
    assert "   3    print *, i\n" in result.stdout
    assert "   4  end program xdel\n" in result.stdout
    assert "   4    i = 1\n" not in result.stdout
    assert "i = 2" not in result.stdout


def test_repl_del_open_ended_ranges(tmp_path):
    source = tmp_path / "xdelopen.f90"
    source.write_text(
        "program xdelopen\n"
        "integer :: i\n"
        "i = 1\n"
        "print *, i\n"
        "end program xdelopen\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--load", str(source)],
        cwd=ROOT,
        input=".del :2\n.list\n.del 2:\n.list\n.clear\n.quit\n",
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert "   1  i = 1\n" in result.stdout
    assert "   2  print *, i\n" in result.stdout
    assert "end program xdelopen" in result.stdout
    assert result.stdout.count("   1  i = 1\n") == 2
    assert "   2  end program xdelopen\n" in result.stdout


def test_repl_del_rejects_footer_line(tmp_path):
    source = tmp_path / "xdelfooter.f90"
    source.write_text(
        "program xdelfooter\n"
        "print *, 1\n"
        "end program xdelfooter\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--load", str(source)],
        cwd=ROOT,
        input=".del 3\n.list\n.clear\n.quit\n",
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0
    assert ".del range is outside the editable source buffer" in result.stderr
    assert "   3  end program xdelfooter\n" in result.stdout


def test_repl_ins_and_rep_edit_lines(tmp_path):
    source = tmp_path / "xedit.f90"
    source.write_text(
        "program xedit\n"
        "integer :: i\n"
        "i = 1\n"
        "print *, i\n"
        "end program xedit\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--load", str(source)],
        cwd=ROOT,
        input=(
            ".ins 3 integer :: j\n"
            ".rep 4 i = 10\n"
            ".ins 6 print *, i\n"
            ".list\n"
            ".clear\n"
            ".quit\n"
        ),
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert "   1  program xedit\n" in result.stdout
    assert "   2    integer :: i\n" in result.stdout
    assert "   3    integer :: j\n" in result.stdout
    assert "   4    i = 10\n" in result.stdout
    assert "   5    print *, i\n" in result.stdout
    assert "   6    print *, i\n" in result.stdout
    assert "   7  end program xedit\n" in result.stdout
    assert "   4    i = 1\n" not in result.stdout


def test_repl_ins_rep_reject_footer_line(tmp_path):
    source = tmp_path / "xeditfooter.f90"
    source.write_text(
        "program xeditfooter\n"
        "print *, 1\n"
        "end program xeditfooter\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--load", str(source)],
        cwd=ROOT,
        input=".rep 3 end\n.ins 4 print *, 2\n.list\n.clear\n.quit\n",
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0
    assert ".rep line is outside the editable source buffer" in result.stderr
    assert ".ins line is outside the editable source buffer" in result.stderr
    assert "   3  end program xeditfooter\n" in result.stdout


def test_repl_rename_variable_tokens(tmp_path):
    source = tmp_path / "xrename.f90"
    source.write_text(
        "program xrename\n"
        "integer :: i\n"
        "integer :: idx\n"
        "i = 2\n"
        "print *, i, idx\n"
        "print *, \"i should stay\"\n"
        "! i should stay in comment\n"
        "end program xrename\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--load", str(source)],
        cwd=ROOT,
        input=".rename i j\n.list\n.clear\n.quit\n",
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert "integer :: j" in result.stdout
    assert "integer :: idx" in result.stdout
    assert "j = 2" in result.stdout
    assert "print *, j, idx" in result.stdout
    assert '"i should stay"' in result.stdout
    assert "! i should stay in comment" in result.stdout
    assert "   2    integer :: i\n" not in result.stdout
    assert "   4    i = 2\n" not in result.stdout


def test_repl_rename_rejects_existing_name(tmp_path):
    source = tmp_path / "xrename_conflict.f90"
    source.write_text(
        "program xrename_conflict\n"
        "integer :: i\n"
        "integer :: j\n"
        "i = 2\n"
        "end program xrename_conflict\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--load", str(source)],
        cwd=ROOT,
        input=".rename i j\n.list\n.clear\n.quit\n",
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0
    assert ".rename: j already exists" in result.stderr
    assert "integer :: i" in result.stdout
    assert "integer :: j" in result.stdout
    assert "i = 2" in result.stdout


def test_repl_rename_rejects_missing_old_name(tmp_path):
    source = tmp_path / "xrename_missing.f90"
    source.write_text(
        "program xrename_missing\n"
        "integer :: i\n"
        "i = 2\n"
        "end program xrename_missing\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--load", str(source)],
        cwd=ROOT,
        input=".rename k j\n.list\n.clear\n.quit\n",
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0
    assert ".rename: k not found" in result.stderr
    assert "integer :: i" in result.stdout
    assert "i = 2" in result.stdout


def test_repl_decl_lists_declaration_lines(tmp_path):
    source = tmp_path / "xdecl.f90"
    source.write_text(
        "program xdecl\n"
        "implicit none\n"
        "integer :: i\n"
        "real :: x(2)\n"
        "i = 2\n"
        "print *, i\n"
        "end program xdecl\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--load", str(source)],
        cwd=ROOT,
        input=".decl\n.clear\n.quit\n",
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert "   2    implicit none\n" in result.stdout
    assert "   3    integer :: i\n" in result.stdout
    assert "   4    real :: x(2)\n" in result.stdout
    assert "i = 2" not in result.stdout
    assert "print *, i" not in result.stdout


def test_repl_list_auto_indents_blocks(tmp_path):
    source = tmp_path / "xindent.f90"
    source.write_text(
        "program x\n"
        "integer :: i\n"
        "do i = 1, 2\n"
        "if (i == 1) then\n"
        "print *, i\n"
        "else\n"
        "print *, -i\n"
        "end if\n"
        "end do\n"
        "end program x\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--load", str(source)],
        cwd=ROOT,
        input=".list\n.clear\n.quit\n",
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert "   3    do i = 1, 2\n" in result.stdout
    assert "   4      if (i == 1) then\n" in result.stdout
    assert "   5        print *, i\n" in result.stdout
    assert "   6      else\n" in result.stdout
    assert "   8      end if\n" in result.stdout
    assert "   9    end do\n" in result.stdout
    assert "  10  end program x\n" in result.stdout


def test_rejects_type_changing_assignment():
    source = CASES / "xtype_change.f90"
    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode != 0
    assert result.stdout == ""
    assert "Cannot assign CHARACTER to INTEGER variable 'i'" in result.stderr
    assert 'line 4: i = "a"' in result.stderr


def test_repl_print_shortcut_is_stored_as_fortran(tmp_path):
    source = tmp_path / "repl_print_shortcut.f90"
    source.write_text("integer :: i = 2\n", encoding="utf-8")

    result = subprocess.run(
        [str(OFORT), "--load", str(source)],
        cwd=ROOT,
        input="print i,i+1,\"x\"\n.list\n.\n.clear\n.quit\n",
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert "   2  print *, i,i+1,\"x\"\n" in result.stdout
    assert "2 3 x\n" in result.stdout


def test_repl_let_const_shortcuts_are_stored_as_fortran(tmp_path):
    source = tmp_path / "repl_let_const_shortcut.f90"
    source.write_text("", encoding="utf-8")

    result = subprocess.run(
        [str(OFORT), "--load", str(source)],
        cwd=ROOT,
        input=(
            "let i = 2\n"
            "let x = 2.5\n"
            "let s = \"abc\"\n"
            "const n = 10\n"
            "const ok = .true.\n"
            ".list\n"
            "print i,x,s,n,ok\n"
            ".\n"
            ".clear\n"
            ".quit\n"
        ),
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert "integer :: i\n" in result.stdout
    assert "i = 2\n" in result.stdout
    assert "real :: x\n" in result.stdout
    assert "x = 2.5\n" in result.stdout
    assert "character(len=3) :: s\n" in result.stdout
    assert "s = \"abc\"\n" in result.stdout
    assert "integer, parameter :: n = 10\n" in result.stdout
    assert "logical, parameter :: ok = .true.\n" in result.stdout
    assert "2 2.5 abc 10 T\n" in result.stdout


def test_repl_const_kind_shortcut_is_integer_parameter(tmp_path):
    source = tmp_path / "repl_const_kind_shortcut.f90"
    source.write_text("implicit none\n", encoding="utf-8")

    result = subprocess.run(
        [str(OFORT), "--load", str(source)],
        cwd=ROOT,
        input="const dp = kind(1.0d0)\n.list\nprint dp\n.\n.clear\n.quit\n",
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert "integer, parameter :: dp = kind(1.0d0)\n" in result.stdout
    assert "8\n" in result.stdout


def test_repl_let_const_existing_names_and_reconst(tmp_path):
    source = tmp_path / "repl_reconst_shortcut.f90"
    source.write_text("implicit none\n", encoding="utf-8")

    result = subprocess.run(
        [str(OFORT), "--load", str(source)],
        cwd=ROOT,
        input=(
            "const n = 4\n"
            "let m = 5\n"
            "n*m\n"
            "let m = 7\n"
            "const n = 8\n"
            "reconst n = 8\n"
            "n*m\n"
            ".list\n"
            ".clear\n"
            ".quit\n"
        ),
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert "LET variable 'm' already exists; use assignment: m = ..." in result.stderr
    assert "CONST name 'n' already exists; use reconst n = ... to replace a parameter" in result.stderr
    assert "ofort> 20\n" in result.stdout
    assert "ofort> 40\n" in result.stdout
    assert "integer, parameter :: n = 8\n" in result.stdout
    assert result.stdout.count("integer :: m\n") == 1
    assert "m = 5\n" in result.stdout
    assert "m = 7\n" not in result.stdout


def test_repl_implicit_none_first_line_has_no_spurious_text(tmp_path):
    source = tmp_path / "repl_implicit_none.f90"
    source.write_text("", encoding="utf-8")

    result = subprocess.run(
        [str(OFORT), "--load", str(source)],
        cwd=ROOT,
        input="implicit none\n.list\n.clear\n.quit\n",
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert "   1  implicit none\n" in result.stdout
    assert "   2  P\n" not in result.stdout


def test_repl_malformed_let_const_are_not_shortcuts(tmp_path):
    source = tmp_path / "repl_bad_let_const_shortcut.f90"
    source.write_text("", encoding="utf-8")

    result = subprocess.run(
        [str(OFORT), "--load", str(source)],
        cwd=ROOT,
        input="let = 3\nconst = .true.\n.list\n.clear\n.quit\n",
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert "   1  let = 3\n" in result.stdout
    assert "   2  const = .true.\n" in result.stdout


def test_pure_procedure_rejects_io(tmp_path):
    source = tmp_path / "xpure_io.f90"
    source.write_text(
        """
module m
implicit none
contains
pure subroutine s()
print*,"in s"
end subroutine s
end module m

program main
implicit none
use m
call s()
end program main
""".lstrip(),
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode != 0
    assert result.stdout == ""
    assert "PRINT statement is not allowed in PURE procedure 's'" in result.stderr
    assert 'line 5: print*,"in s"' in result.stderr


def test_pure_procedure_rejects_random_number(tmp_path):
    source = tmp_path / "xpure_random_number.f90"
    source.write_text(
        """
module m
implicit none
contains
pure subroutine s()
real :: x
call random_number(x)
end subroutine s
end module m

program main
implicit none
use m
call s()
end program main
""".lstrip(),
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode != 0
    assert result.stdout == ""
    assert "Impure intrinsic subroutine 'random_number' is not allowed in PURE procedure 's'" in result.stderr
    assert "line 6: call random_number(x)" in result.stderr


def test_pure_procedure_reports_multiple_violations(tmp_path):
    source = tmp_path / "xpure.f90"
    source.write_text(
        """
module m
implicit none
real :: y
contains
pure subroutine s1()
print*,"in s1"
end subroutine s1

pure subroutine s2()
real :: x
call random_number(x)
end subroutine s2

pure subroutine s3()
y = 0.0
end subroutine s3

pure subroutine s4()
integer :: n
call random_seed(size=n)
end subroutine s4
end module m

program main
implicit none
use m
call s1()
call s2()
end program main
""".lstrip(),
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode != 0
    assert result.stdout == ""
    assert "PRINT statement is not allowed in PURE procedure 's1'" in result.stderr
    assert 'line 6: print*,"in s1"' in result.stderr
    assert "Impure intrinsic subroutine 'random_number' is not allowed in PURE procedure 's2'" in result.stderr
    assert "line 11: call random_number(x)" in result.stderr
    assert "Variable 'y' cannot appear in a variable definition context in PURE procedure 's3'" in result.stderr
    assert "line 15: y = 0.0" in result.stderr
    assert "Impure intrinsic subroutine 'random_seed' is not allowed in PURE procedure 's4'" in result.stderr
    assert "line 20: call random_seed(size=n)" in result.stderr


def test_matmul_matrix_vector_and_vector_matrix(tmp_path):
    source = tmp_path / "xmatmul_vector.f90"
    source.write_text(
        """
program main
implicit none
real(8) :: a(2,3), b(3,2), x(3), y(3)
a = reshape([1.0d0,2.0d0,3.0d0,4.0d0,5.0d0,6.0d0], [2,3])
b = reshape([1.0d0,2.0d0,3.0d0,4.0d0,5.0d0,6.0d0], [3,2])
x = [10.0d0,20.0d0,30.0d0]
y = [10.0d0,20.0d0,30.0d0]
print *, matmul(a, x)
print *, matmul(y, b)
end program main
""".lstrip(),
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert result.stdout == "220 280\n140 320\n"


def test_ofort_statistics_mod_vector_functions(tmp_path):
    source = tmp_path / "xofort_statistics_mod.f90"
    source.write_text(
        """
program main
use ofort_statistics_mod, only: mean, variance, sd, cov, cor, variance_given_mean, sd_given_mean
implicit none
real(8) :: x(4), y(4)
real(8) :: xm
x = [1.0d0, 2.0d0, 3.0d0, 4.0d0]
y = [2.0d0, 4.0d0, 6.0d0, 8.0d0]
xm = mean(x)
print *, mean(x)
print *, variance(x)
print *, sd(x)
print *, cov(x, y)
print *, cor(x, y)
print *, variance_given_mean(x, xm)
print *, sd_given_mean(x, xm)
end program main
""".lstrip(),
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    lines = result.stdout.splitlines()
    assert float(lines[0]) == pytest.approx(2.5)
    assert float(lines[1]) == pytest.approx(1.6666666666666667)
    assert float(lines[2]) == pytest.approx(1.2909944487358056)
    assert float(lines[3]) == pytest.approx(3.3333333333333335)
    assert float(lines[4]) == pytest.approx(1.0)
    assert float(lines[5]) == pytest.approx(1.6666666666666667)
    assert float(lines[6]) == pytest.approx(1.2909944487358056)


def test_ofort_statistics_mod_calc_stats(tmp_path):
    source = tmp_path / "xcalc_stats.f90"
    source.write_text(
        """
program main
use ofort_statistics_mod, only: calc_stats
implicit none
real(8) :: x(4)
real(8) :: xm, xs, xv
real(8) :: xm2, xv2
x = [1.0d0, 2.0d0, 3.0d0, 4.0d0]
call calc_stats(x, mean=xm, sd=xs, var=xv)
call calc_stats(x, xm2, var=xv2)
print *, xm
print *, xs
print *, xv
print *, xm2
print *, xv2
end program main
""".lstrip(),
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--fast", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    lines = result.stdout.splitlines()
    assert float(lines[0]) == pytest.approx(2.5)
    assert float(lines[1]) == pytest.approx(1.2909944487358056)
    assert float(lines[2]) == pytest.approx(1.6666666666666667)
    assert float(lines[3]) == pytest.approx(2.5)
    assert float(lines[4]) == pytest.approx(1.6666666666666667)


def test_ofort_statistics_mod_calc_col_stats(tmp_path):
    source = tmp_path / "xcalc_col_stats.f90"
    source.write_text(
        """
program main
use ofort_statistics_mod, only: calc_col_stats, cov, cor
implicit none
real(8) :: x(3,2)
real(8) :: mu(2), xs(2), xv(2), c(2,2), r(2,2)
real(8) :: rms(2), c_zm(2,2), r_zm(2,2)
x(1,1) = 1.0d0
x(2,1) = 2.0d0
x(3,1) = 3.0d0
x(1,2) = 2.0d0
x(2,2) = 4.0d0
x(3,2) = 6.0d0
call calc_col_stats(x, mean=mu, sd=xs, var=xv, cov=c, corr=r, rms=rms, cov_zm=c_zm, corr_zm=r_zm)
print *, mu
print *, xs
print *, xv
print *, c
print *, r
print *, rms
print *, c_zm
print *, r_zm
print *, cov(x)
print *, cor(x)
end program main
""".lstrip(),
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--fast", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    vals = [float(x) for x in result.stdout.split()]
    assert vals[0:2] == pytest.approx([2.0, 4.0])
    assert vals[2:4] == pytest.approx([1.0, 2.0])
    assert vals[4:6] == pytest.approx([1.0, 4.0])
    assert vals[6:10] == pytest.approx([1.0, 2.0, 2.0, 4.0])
    assert vals[10:14] == pytest.approx([1.0, 1.0, 1.0, 1.0])
    assert vals[14:16] == pytest.approx([(14.0 / 3.0) ** 0.5, (56.0 / 3.0) ** 0.5])
    assert vals[16:20] == pytest.approx([14.0 / 3.0, 28.0 / 3.0, 28.0 / 3.0, 56.0 / 3.0])
    assert vals[20:24] == pytest.approx([1.0, 1.0, 1.0, 1.0])
    assert vals[24:28] == pytest.approx([1.0, 2.0, 2.0, 4.0])
    assert vals[28:32] == pytest.approx([1.0, 1.0, 1.0, 1.0])


def test_ofort_la_mod_initial_functions(tmp_path):
    source = tmp_path / "xofort_la_mod.f90"
    source.write_text(
        """
program main
use ofort_la_mod, only: matmul2, transpose2, crossprod, tcrossprod, center_cols, col_sums, col_means
implicit none
real(8) :: a(2,2), b(2,2), mu(2), centered(2,2)
a(1,1) = 1.0d0
a(2,1) = 2.0d0
a(1,2) = 3.0d0
a(2,2) = 4.0d0
b(1,1) = 5.0d0
b(2,1) = 6.0d0
b(1,2) = 7.0d0
b(2,2) = 8.0d0
mu = col_means(a)
call center_cols(a, mu, centered)
print *, col_sums(a)
print *, mu
print *, transpose2(a)
print *, matmul2(a, b)
print *, crossprod(a)
print *, tcrossprod(a)
print *, centered
end program main
""".lstrip(),
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--fast", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    vals = [float(x) for x in result.stdout.split()]
    assert vals[0:2] == pytest.approx([3.0, 7.0])
    assert vals[2:4] == pytest.approx([1.5, 3.5])
    assert vals[4:8] == pytest.approx([1.0, 3.0, 2.0, 4.0])
    assert vals[8:12] == pytest.approx([23.0, 34.0, 31.0, 46.0])
    assert vals[12:16] == pytest.approx([5.0, 11.0, 11.0, 25.0])
    assert vals[16:20] == pytest.approx([10.0, 14.0, 14.0, 20.0])
    assert vals[20:24] == pytest.approx([-0.5, 0.5, -0.5, 0.5])


def test_ofort_io_mod_read_matrix_and_vector(tmp_path):
    matrix_file = tmp_path / "matrix.txt"
    matrix_file.write_text(
        """
# comment
1 2 3
4 5 6
""".lstrip(),
        encoding="utf-8",
    )
    prices_file = tmp_path / "prices.csv"
    prices_file.write_text(
        """
date,SPY,TLT
2024-01-02,472.65,97.12
2024-01-03,468.79,98.04
""".lstrip(),
        encoding="utf-8",
    )
    vector_file = tmp_path / "vector.txt"
    vector_file.write_text("10\n20 30\n", encoding="utf-8")
    matrix_path = str(matrix_file).replace("\\", "/")
    prices_path = str(prices_file).replace("\\", "/")
    vector_path = str(vector_file).replace("\\", "/")

    source = tmp_path / "xofort_io_mod.f90"
    source.write_text(
        f"""
program main
use ofort_io_mod, only: read_matrix, read_vector
implicit none
real(8), allocatable :: a(:,:), prices(:,:), v(:)
character(len=20), allocatable :: dates(:)
call read_matrix("{matrix_path}", a)
call read_matrix("{prices_path}", prices, delimiter=",", header=.true., ncol=2, row_labels=dates)
call read_vector("{vector_path}", v)
print *, size(a, 1), size(a, 2)
print *, a
print *, size(prices, 1), size(prices, 2)
print *, trim(dates(1)), trim(dates(2))
print *, prices
print *, size(v)
print *, v
end program main
""".lstrip(),
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--fast", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert "2024-01-02" in result.stdout
    assert "2024-01-03" in result.stdout
    numeric_stdout = result.stdout.replace("2024-01-02", "").replace("2024-01-03", "")
    vals = [float(x) for x in numeric_stdout.split()]
    assert vals[0:2] == pytest.approx([2.0, 3.0])
    assert vals[2:8] == pytest.approx([1.0, 4.0, 2.0, 5.0, 3.0, 6.0])
    assert vals[8:10] == pytest.approx([2.0, 2.0])
    assert vals[10:14] == pytest.approx([472.65, 468.79, 97.12, 98.04])
    assert vals[14:18] == pytest.approx([3.0, 10.0, 20.0, 30.0])


def test_random_number_accepts_array_section_harvest(tmp_path):
    source = tmp_path / "xrandom_number_section.f90"
    source.write_text(
        """
program main
implicit none
integer :: m
real(8) :: u(5)
m = 3
u = -1.0d0
call random_number(u(1:m))
print *, u(4), u(5)
end program main
""".lstrip(),
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--fast", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert result.stdout == "-1 -1\n"


def test_ofort_random_mod_rnorm_fill(tmp_path):
    source = tmp_path / "xrnorm_fill.f90"
    source.write_text(
        """
program main
use ofort_random_mod, only: rnorm, rnorm_fill
use ofort_statistics_mod, only: variance
implicit none
real(8) :: x(1000), y(1000), z(20, 10)
x = 0.0d0
call rnorm_fill(x, 1)
call rnorm_fill(y, 2)
call rnorm_fill(z)
print *, variance(x) > 0.0d0
print *, variance(y) > 0.0d0
print *, variance(rnorm(1000, 2)) > 0.0d0
print *, variance(reshape(z, [200])) > 0.0d0
end program main
""".lstrip(),
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--fast", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert result.stdout == "T\nT\nT\nT\n"


def test_write_and_read_external_file(tmp_path):
    source = CASES / "xwrite_file.f90"
    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=tmp_path,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert result.stdout == "ichk =  10 20 30\nsum(abs(i-ichk)) =  0\n"
    assert (tmp_path / "temp.txt").read_text(encoding="utf-8") == "10 20 30\n"


def test_write_read_internal_file_and_allocatable(tmp_path):
    source = CASES / "xwrite_file_alloc.f90"
    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=tmp_path,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert result.stdout == "ichk =  10.1 20.1 30.1\nsum(abs(i-ichk)) =  0\n"
    assert (tmp_path / "temp.txt").read_text(encoding="utf-8") == "3 10.1 20.1 30.1\n"


def test_unformatted_stream_io(tmp_path):
    source = CASES / "xstream.f90"
    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=tmp_path,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert result.stdout == "ichk =  10.1 20.1 30.1\nsum(abs(i-ichk)) =  0\n"
    assert (tmp_path / "temp.bin").read_text(encoding="utf-8") == "3\n10.1\n20.1\n30.1\n"


def test_exit_from_unbounded_do_loop():
    source = CASES / "xexit.f90"
    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=10,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    lines = result.stdout.splitlines()
    assert lines
    assert lines[-1].startswith("big ")
    assert float(lines[-1].split()[1]) > 0.9
    for line in lines[:-1]:
        assert 0.0 <= float(line) <= 0.9


def test_check_parses_without_running(tmp_path):
    source = tmp_path / "xcheck.f90"
    source.write_text(
        "program xcheck\n"
        "print *, 12345\n"
        "end program xcheck\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--check", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert result.stdout == "ofort check passed\n"


def test_check_rejects_syntax_error(tmp_path):
    source = tmp_path / "xbad.f90"
    source.write_text(
        "program xbad\n"
        "print *, (1\n"
        "end program xbad\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--check", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode != 0
    assert result.stdout == ""
    assert result.stderr != ""


def test_check_skips_generic_interface_block(tmp_path):
    source = tmp_path / "xinterface.f90"
    source.write_text(
        "module m\n"
        "interface g\n"
        "  module procedure s\n"
        "end interface g\n"
        "contains\n"
        "subroutine s()\n"
        "end subroutine s\n"
        "end module m\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--check", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert result.stdout == "ofort check passed\n"


def test_check_accepts_utf8_bom(tmp_path):
    source = tmp_path / "xbom.f90"
    source.write_bytes(
        b"\xef\xbb\xbfprogram xbom\n"
        b"print *, 1\n"
        b"end program xbom\n"
    )

    result = subprocess.run(
        [str(OFORT), "--check", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert result.stdout == "ofort check passed\n"


def test_typed_function_prefixes():
    source = CASES / "xtyped_function.f90"
    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert result.stdout == "6\n7.5\n"


def test_type_keyword_intrinsic_call():
    source = CASES / "xtype_keyword_intrinsic.f90"
    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert result.stdout == "3 4\n"


def test_batch_runner_runs_file_glob(tmp_path):
    (tmp_path / "a.f90").write_text("print *, 11\n", encoding="utf-8")
    (tmp_path / "b.f90").write_text("print *, 22\n", encoding="utf-8")

    result = subprocess.run(
        [sys.executable, str(RUNNER), str(tmp_path / "*.f90")],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert "==> " in result.stdout
    assert "a.f90" in result.stdout
    assert "b.f90" in result.stdout
    assert "(1 lines)" in result.stdout
    assert "\n\n==> " in result.stdout
    assert "11" in result.stdout
    assert "22" in result.stdout
    assert re.search(r"2 passed in \d+\.\d{2}s", result.stdout)


def test_batch_runner_forwards_check(tmp_path):
    (tmp_path / "a.f90").write_text("print *, 11\n", encoding="utf-8")
    (tmp_path / "b.f90").write_text("print *, 22\n", encoding="utf-8")

    result = subprocess.run(
        [sys.executable, str(RUNNER), "--check", str(tmp_path / "*.f90")],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert result.stdout.count("ofort check passed") == 2
    output_lines = result.stdout.splitlines()
    assert "11" not in output_lines
    assert "22" not in output_lines
    assert re.search(r"2 passed in \d+\.\d{2}s", result.stdout)


def test_batch_runner_limit(tmp_path):
    (tmp_path / "a.f90").write_text("print *, 11\n", encoding="utf-8")
    (tmp_path / "b.f90").write_text("print *, 22\n", encoding="utf-8")
    (tmp_path / "c.f90").write_text("print *, 33\n", encoding="utf-8")

    result = subprocess.run(
        [sys.executable, str(RUNNER), "--limit", "2", str(tmp_path / "*.f90")],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    output_lines = result.stdout.splitlines()
    assert "11" in output_lines
    assert "22" in output_lines
    assert "33" not in output_lines
    assert re.search(r"2 passed in \d+\.\d{2}s", result.stdout)


def test_batch_runner_max_lines_skips_long_files(tmp_path):
    (tmp_path / "a.f90").write_text("print *, 11\n", encoding="utf-8")
    (tmp_path / "b.f90").write_text(
        "print *, 22\n"
        "print *, 33\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [sys.executable, str(RUNNER), "--max-lines", "1", str(tmp_path / "*.f90")],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert "a.f90" in result.stdout
    assert "(1 lines)" in result.stdout
    output_lines = result.stdout.splitlines()
    assert "11" in output_lines
    assert "b.f90" not in result.stdout
    assert "22" not in output_lines
    assert "(2 lines)" not in result.stdout
    assert "skipped: longer than 1 lines" not in result.stdout
    assert re.search(r"1 passed, 1 skipped in \d+\.\d{2}s", result.stdout)


def test_batch_runner_quiet_suppresses_success_output(tmp_path):
    (tmp_path / "a.f90").write_text("print *, 11\n", encoding="utf-8")
    (tmp_path / "b.f90").write_text("print *, 22\n", encoding="utf-8")

    result = subprocess.run(
        [sys.executable, str(RUNNER), "--quiet", str(tmp_path / "*.f90")],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stdout == ""
    assert result.stderr == ""


def test_batch_runner_filter_skips_rejected_files(tmp_path):
    good = tmp_path / "good.f90"
    bad = tmp_path / "bad.f90"
    filter_script = tmp_path / "filter.py"
    good.write_text("print *, 11\n", encoding="utf-8")
    bad.write_text("print *, 22\n", encoding="utf-8")
    filter_script.write_text(
        "import pathlib\n"
        "import sys\n"
        "raise SystemExit(0 if pathlib.Path(sys.argv[-1]).name == 'good.f90' else 1)\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [
            sys.executable,
            str(RUNNER),
            "--filter",
            f'"{sys.executable}" "{filter_script}"',
            str(tmp_path / "*.f90"),
        ],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stderr
    assert result.stderr == ""
    assert "good.f90" in result.stdout
    output_lines = result.stdout.splitlines()
    assert "11" in output_lines
    assert "bad.f90" not in result.stdout
    assert "22" not in output_lines
    assert re.search(r"1 passed, 1 skipped in \d+\.\d{2}s", result.stdout)


def test_batch_runner_quiet_prints_failed_files(tmp_path):
    good = tmp_path / "good.f90"
    bad = tmp_path / "bad.f90"
    fake_ofort = tmp_path / "fake_ofort.bat"
    good.write_text("print *, 11\n", encoding="utf-8")
    bad.write_text("print *, 22\n", encoding="utf-8")
    fake_ofort.write_text(
        "@echo off\n"
        "echo handled %~nx1\n"
        "echo problem %~nx1 1>&2\n"
        "if /I \"%~nx1\"==\"bad.f90\" exit /b 1\n"
        "exit /b 0\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [
            sys.executable,
            str(RUNNER),
            "--quiet",
            "--ofort",
            str(fake_ofort),
            str(tmp_path / "*.f90"),
        ],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 1
    assert "bad.f90" in result.stdout
    assert "handled bad.f90" in result.stdout
    assert "good.f90" not in result.stdout
    assert "handled good.f90" not in result.stdout
    assert "problem bad.f90" in result.stderr
    assert "problem good.f90" not in result.stderr
    assert re.search(r"1 of 2 failed in \d+\.\d{2}s", result.stderr)


def test_batch_runner_rejects_bad_limit(tmp_path):
    (tmp_path / "a.f90").write_text("print *, 11\n", encoding="utf-8")

    result = subprocess.run(
        [sys.executable, str(RUNNER), "--limit", "0", str(tmp_path / "*.f90")],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 2
    assert result.stdout == ""
    assert "--limit must be at least 1" in result.stderr


def test_batch_runner_times_out_file(tmp_path):
    source = tmp_path / "a.f90"
    fake_ofort = tmp_path / "fake_ofort.bat"
    source.write_text("print *, 11\n", encoding="utf-8")
    fake_ofort.write_text(
        "@echo off\n"
        f"\"{sys.executable}\" -c \"import time; time.sleep(2)\"\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [
            sys.executable,
            str(RUNNER),
            "--ofort",
            str(fake_ofort),
            "--timeout",
            "0.1",
            str(source),
        ],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 1
    assert "==> " in result.stdout
    assert "(1 lines)" in result.stdout
    assert "timed out after 0.1 seconds" in result.stderr
    assert re.search(r"1 of 1 failed in \d+\.\d{2}s", result.stderr)


def test_batch_runner_rejects_bad_timeout(tmp_path):
    (tmp_path / "a.f90").write_text("print *, 11\n", encoding="utf-8")

    result = subprocess.run(
        [sys.executable, str(RUNNER), "--timeout", "-1", str(tmp_path / "*.f90")],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 2
    assert result.stdout == ""
    assert "--timeout must be non-negative" in result.stderr


def test_batch_runner_rejects_bad_max_lines(tmp_path):
    (tmp_path / "a.f90").write_text("print *, 11\n", encoding="utf-8")

    result = subprocess.run(
        [sys.executable, str(RUNNER), "--max-lines", "-1", str(tmp_path / "*.f90")],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 2
    assert result.stdout == ""
    assert "--max-lines must be non-negative" in result.stderr


def test_fixed_form_source_by_extension(tmp_path):
    source = tmp_path / "xfixed.f"
    source.write_text(
        "      program x\n"
        "      integer i\n"
        "      i = 3\n"
        "      print *, i\n"
        "      end\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stdout + result.stderr
    assert result.stderr == ""
    assert result.stdout.split() == ["3"]


def test_fixed_form_forced_on_stdin():
    source = (
        "      program x\n"
        "      print *, 12\n"
        "      end\n"
    )

    result = subprocess.run(
        [str(OFORT), "--fixed-form"],
        cwd=ROOT,
        input=source,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stdout + result.stderr
    assert result.stderr == ""
    assert result.stdout.split() == ["12"]


def test_save_free_writes_converted_f90(tmp_path):
    source = tmp_path / "xfixed_save.f"
    saved = tmp_path / "xfixed_save.f90"
    source.write_text(
        "      program x\n"
        "      integer i\n"
        "      i = 7\n"
        "      print *, i\n"
        "      end\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--save-free", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stdout + result.stderr
    assert result.stderr == ""
    assert saved.exists()
    assert "program x" in saved.read_text(encoding="utf-8").lower()
    assert result.stdout.split()[-1] == "7"


def test_compact_endtype_with_name_checks(tmp_path):
    source = tmp_path / "xcompact_endtype.f90"
    source.write_text(
        "module m\n"
        "  type t\n"
        "    integer :: i\n"
        "  endtype t\n"
        "end module\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--check", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stdout + result.stderr


def test_implicit_parameterized_type_and_unlimited_type_check(tmp_path):
    source = tmp_path / "ximplicit_parameterized_type.f90"
    source.write_text(
        "module m\n"
        "  type t(k)\n"
        "    integer, kind :: k = 4\n"
        "    integer(k) :: i\n"
        "  end type\n"
        "end module\n"
        "subroutine s(a, b)\n"
        "  use m\n"
        "  implicit type(t(2))(a), class(t)(c)\n"
        "  type(*) :: b\n"
        "end subroutine\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--check", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stdout + result.stderr


def test_semantic_check_allows_module_and_local_type_constructors(tmp_path):
    source = tmp_path / "xtype_constructor_check.f90"
    source.write_text(
        "module m\n"
        "  implicit none\n"
        "  type ty\n"
        "    integer :: i = 1\n"
        "    integer :: j = 2\n"
        "  end type\n"
        "end module\n"
        "program main\n"
        "  use m\n"
        "  implicit none\n"
        "  type con\n"
        "    type(ty) :: x\n"
        "    integer :: k\n"
        "  end type\n"
        "  type(ty) :: a\n"
        "  type(con) :: b\n"
        "  a = ty(3, 4)\n"
        "  b = con(ty(5, 6), 7)\n"
        "end program\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--check", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stdout + result.stderr


def test_old_style_character_dimension_then_length_check(tmp_path):
    source = tmp_path / "xold_character_decl.f90"
    source.write_text(
        "subroutine s(a, b, c)\n"
        "  integer :: n\n"
        "  parameter (n = 3)\n"
        "  character a(n)*(*)\n"
        "  character*10 b, c(:)*(*)\n"
        "end subroutine\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--check", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stdout + result.stderr


def test_derived_type_dimension_assumed_size_check(tmp_path):
    source = tmp_path / "xtype_dimension_star.f90"
    source.write_text(
        "module m\n"
        "  type v\n"
        "    integer :: y\n"
        "  end type\n"
        "contains\n"
        "  subroutine s(z)\n"
        "    type(v), dimension(*) :: z\n"
        "  end subroutine\n"
        "end module\n",
        encoding="utf-8",
    )

    result = subprocess.run(
        [str(OFORT), "--check", str(source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=5,
    )

    assert result.returncode == 0, result.stdout + result.stderr
