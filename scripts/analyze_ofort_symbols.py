#!/usr/bin/env python3
"""Extract Fortran keywords and intrinsic procedure names from the C sources.

The most reliable source for this information is the interpreter tables and
dispatch logic in src/ofort.c.  This script intentionally extracts from those
places instead of trying to infer support from tests or README prose.
"""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_SOURCE = ROOT / "src" / "ofort.c"
DEFAULT_OUTPUT = ROOT / "ofort_symbols.txt"
DEFAULT_KEYWORD_PROGRAM_DIR = ROOT / "keyword_name_programs"


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="replace")


def extract_block(text: str, start_pattern: str, end_pattern: str) -> str:
    start = re.search(start_pattern, text, flags=re.MULTILINE)
    if not start:
        return ""
    end = re.search(end_pattern, text[start.end() :], flags=re.MULTILINE)
    if not end:
        return ""
    return text[start.end() : start.end() + end.start()]


def extract_fortran_keywords(text: str) -> set[str]:
    block = extract_block(
        text,
        r"static\s+const\s+KeywordEntry\s+fortran_keywords\[\]\s*=\s*\{",
        r"\};",
    )
    keywords = set(re.findall(r'\{\s*"([A-Za-z_][A-Za-z0-9_]*)"\s*,\s*FTOK_', block))

    # These are recognized by special lexer/parser logic rather than direct
    # single-word entries in fortran_keywords[].
    if "DOUBLE" in keywords:
        keywords.add("DOUBLE PRECISION")
    if "ELSE" in keywords and "IF" in keywords:
        keywords.add("ELSE IF")

    return keywords


def extract_dotted_words(text: str) -> set[str]:
    return {
        f".{name}."
        for name in re.findall(r'strcmp\s*\(\s*dotword\s*,\s*"([A-Za-z_][A-Za-z0-9_]*)"\s*\)', text)
    }


def extract_intrinsic_name_table(text: str) -> set[str]:
    block = extract_block(
        text,
        r"static\s+const\s+char\s+\*intrinsic_names\[\]\s*=\s*\{",
        r"\s+NULL\s*\n\};",
    )
    return set(re.findall(r'"([A-Z][A-Z0-9_]*)"', block))


def extract_call_intrinsic_names(text: str) -> set[str]:
    block = extract_block(
        text,
        r"static\s+OfortValue\s+call_intrinsic\s*\(",
        r"\n\}\s*\n\s*static\s+void\s+ofort_init_common",
    )
    return set(re.findall(r'strcmp\s*\(\s*upper\s*,\s*"([A-Z][A-Z0-9_]*)"\s*\)', block))


def extract_intrinsic_subroutines(text: str) -> set[str]:
    names = set(re.findall(r'strcmp\s*\(\s*call_upper\s*,\s*"([A-Z][A-Z0-9_]*)"\s*\)', text))
    # FANNKUCHREDUX is a benchmark fast path for a user subroutine name, not a
    # Fortran intrinsic subroutine.
    names.discard("FANNKUCHREDUX")
    return names


def extract_extension_imports(text: str) -> dict[str, set[str]]:
    imports: dict[str, set[str]] = {}
    current_module: str | None = None
    block = extract_block(
        text,
        r'if\s*\(\s*str_eq_nocase\s*\(\s*n->name\s*,\s*"ofort_random_mod"\s*\)\s*\)',
        r'if\s*\(\s*strcmp\s*\(\s*upper\s*,\s*"ISO_FORTRAN_ENV"\s*\)',
    )
    current_module = "ofort_random_mod"
    imports.setdefault(current_module, set())

    for line in block.splitlines():
        module_match = re.search(r'str_eq_nocase\s*\(\s*n->name\s*,\s*"([^"]+)"\s*\)', line)
        if module_match:
            current_module = module_match.group(1)
            imports.setdefault(current_module, set())
            continue

        if re.search(r"\}\s*else\s*\{", line):
            current_module = "ofort_statistics_mod"
            imports.setdefault(current_module, set())
            continue

        if current_module:
            import_match = re.search(
                r'import_ofort_extension_intrinsic\s*\([^,]+,\s*"([^"]+)"\s*,\s*"([^"]+)"\s*\)',
                line,
            )
            if import_match:
                imports.setdefault(current_module, set()).add(import_match.group(1))
                continue

    # Keep the alias visible if the canonical statistics module was found.
    if "ofort_statistics_mod" in imports:
        imports.setdefault("ofort_stats_mod", set(imports["ofort_statistics_mod"]))

    return {module: names for module, names in imports.items() if names}


def sorted_names(names: set[str]) -> list[str]:
    return sorted(names, key=lambda s: (s.replace(".", ""), s))


def keyword_program_name(keyword: str) -> str:
    return re.sub(r"[^A-Za-z0-9]+", "_", keyword.lower()).strip("_")


def keyword_name_test_source(keywords: list[str]) -> str:
    simple_keywords = [kw for kw in keywords if " " not in kw]
    lines = ["program keyword_name_matrix", "  implicit none"]
    lines.extend(f"  integer :: {kw}" for kw in simple_keywords)
    for i, kw in enumerate(simple_keywords, start=1):
        lines.append(f"  {kw} = {1000 + i}")
        lines.append(f"  print *, {kw}")
    lines.append("end program keyword_name_matrix")
    return "\n".join(lines) + "\n"


def keyword_single_test_source(keyword: str, value: int) -> str:
    program_name = f"keyword_name_{keyword_program_name(keyword)}"
    return "\n".join(
        [
            f"program {program_name}",
            "  implicit none",
            f"  integer :: {keyword}",
            f"  {keyword} = {value}",
            f"  print *, {keyword}",
            f"end program {program_name}",
            "",
        ]
    )


def dump_keyword_programs(keywords: list[str], output_dir: Path) -> tuple[int, int]:
    simple_keywords = [kw for kw in keywords if " " not in kw]
    skipped_keywords = [kw for kw in keywords if " " in kw]
    manifest_lines = []

    output_dir.mkdir(parents=True, exist_ok=True)

    combined = output_dir / "keyword_names_all.f90"
    combined.write_text(keyword_name_test_source(keywords), encoding="utf-8")
    manifest_lines.append(combined.name)

    for i, keyword in enumerate(simple_keywords, start=1):
        filename = f"keyword_name_{keyword_program_name(keyword)}.f90"
        path = output_dir / filename
        path.write_text(keyword_single_test_source(keyword, 1000 + i), encoding="utf-8")
        manifest_lines.append(filename)

    if skipped_keywords:
        skipped = output_dir / "skipped_keywords.txt"
        skipped.write_text(
            "\n".join(
                [
                    "Skipped multi-word keyword spellings.",
                    "They are recognized by special lexer/parser logic, but they",
                    "are not valid simple variable names in this generated test.",
                    "",
                    *skipped_keywords,
                    "",
                ]
            ),
            encoding="utf-8",
        )

    (output_dir / "manifest.txt").write_text("\n".join(manifest_lines) + "\n", encoding="utf-8")
    return len(manifest_lines), len(skipped_keywords)


def build_report(source: Path) -> dict[str, object]:
    text = read_text(source)
    intrinsic_table = extract_intrinsic_name_table(text)
    intrinsic_dispatch = extract_call_intrinsic_names(text)
    intrinsic_functions = intrinsic_table | intrinsic_dispatch
    intrinsic_subroutines = extract_intrinsic_subroutines(text)
    extension_imports = extract_extension_imports(text)

    return {
        "source": str(source),
        "keywords": sorted_names(extract_fortran_keywords(text)),
        "dotted_operators_and_literals": sorted_names(extract_dotted_words(text)),
        "intrinsic_functions": sorted_names(intrinsic_functions),
        "intrinsic_subroutines": sorted_names(intrinsic_subroutines),
        "extension_modules": {
            module: sorted_names(names) for module, names in sorted(extension_imports.items())
        },
        "notes": [
            "keywords are extracted from fortran_keywords[] plus special lexer/parser cases",
            "intrinsic functions are extracted from intrinsic_names[] and call_intrinsic() dispatch",
            "intrinsic subroutines are extracted from call_upper dispatch checks",
            "extension module procedures are nonstandard ofort procedures imported by USE statements",
        ],
    }


def render_text_report(report: dict[str, object]) -> str:
    lines: list[str] = []
    lines.append(f"source: {report['source']}")
    lines.append("")

    for key, title in [
        ("keywords", "Fortran keywords"),
        ("dotted_operators_and_literals", "Dotted operators and literals"),
        ("intrinsic_functions", "Intrinsic functions"),
        ("intrinsic_subroutines", "Intrinsic subroutines"),
    ]:
        values = report[key]
        assert isinstance(values, list)
        lines.append(f"{title} ({len(values)})")
        lines.append("-" * len(lines[-1]))
        lines.extend(values)
        lines.append("")

    modules = report["extension_modules"]
    assert isinstance(modules, dict)
    lines.append(f"ofort extension module procedures ({sum(len(v) for v in modules.values())})")
    lines.append("-" * len(lines[-1]))
    for module, names in modules.items():
        lines.append(f"{module}:")
        for name in names:
            lines.append(f"  {name}")
    lines.append("")

    notes = report["notes"]
    assert isinstance(notes, list)
    lines.append("Notes")
    lines.append("-----")
    lines.extend(f"- {note}" for note in notes)
    lines.append("")

    return "\n".join(lines)


def write_text_report(report: dict[str, object], output: Path) -> None:
    output.write_text(render_text_report(report), encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="List Fortran keywords and intrinsic procedures recognized in src/ofort.c."
    )
    parser.add_argument(
        "--source",
        type=Path,
        default=DEFAULT_SOURCE,
        help=f"C source file to analyze (default: {DEFAULT_SOURCE})",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=DEFAULT_OUTPUT,
        help=f"report file to write (default: {DEFAULT_OUTPUT}); use '-' for stdout",
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="write JSON instead of a text report",
    )
    parser.add_argument(
        "--dump-keyword-programs",
        type=Path,
        metavar="DIR",
        help=(
            "write generated keyword-as-variable Fortran programs to DIR; "
            f"default suggestion: {DEFAULT_KEYWORD_PROGRAM_DIR}"
        ),
    )
    args = parser.parse_args()

    report = build_report(args.source)

    if args.dump_keyword_programs:
        keywords = report["keywords"]
        assert isinstance(keywords, list)
        written, skipped = dump_keyword_programs(keywords, args.dump_keyword_programs)
        print(
            f"wrote {written} keyword test programs to {args.dump_keyword_programs} "
            f"({skipped} multi-word keywords skipped)"
        )

    if args.output == Path("-"):
        if args.json:
            print(json.dumps(report, indent=2))
        else:
            print(render_text_report(report), end="")
        return 0

    args.output.parent.mkdir(parents=True, exist_ok=True)
    if args.json:
        args.output.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    else:
        write_text_report(report, args.output)

    print(f"wrote {args.output}")
    print(
        "counts: "
        f"{len(report['keywords'])} keywords, "
        f"{len(report['dotted_operators_and_literals'])} dotted words, "
        f"{len(report['intrinsic_functions'])} intrinsic functions, "
        f"{len(report['intrinsic_subroutines'])} intrinsic subroutines"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
