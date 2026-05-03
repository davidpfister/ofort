#!/usr/bin/env python3
"""Run ofort on programs described by a simple Fortran Makefile."""

from __future__ import annotations

import argparse
import re
import shlex
import subprocess
import sys
import time
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_OFORT = ROOT / ("ofort.exe" if sys.platform.startswith("win") else "ofort")


VAR_REF_RE = re.compile(r"\$\(([^)]+)\)")
ASSIGN_RE = re.compile(r"^([A-Za-z_][A-Za-z0-9_]*)\s*([:+?]?=)\s*(.*)$")
TARGET_RE = re.compile(r"^([^:#=\s][^:#=]*?)\s*:\s*(.*)$")


@dataclass
class Target:
    name: str
    deps: list[str]
    recipe: list[str]


@dataclass
class Program:
    name: str
    sources: list[Path]


def strip_comment(line: str) -> str:
    in_single = False
    in_double = False
    for i, ch in enumerate(line):
        if ch == "'" and not in_double:
            in_single = not in_single
        elif ch == '"' and not in_single:
            in_double = not in_double
        elif ch == "#" and not in_single and not in_double:
            return line[:i]
    return line


def logical_lines(text: str) -> list[str]:
    out: list[str] = []
    current = ""
    for raw in text.splitlines():
        line = raw.rstrip()
        if line.endswith("\\"):
            current += line[:-1] + " "
            continue
        out.append(current + line)
        current = ""
    if current:
        out.append(current)
    return out


def expand_vars(text: str, variables: dict[str, str], depth: int = 0) -> str:
    if depth > 20:
        return text

    def repl(match: re.Match[str]) -> str:
        name = match.group(1)
        return expand_vars(variables.get(name, ""), variables, depth + 1)

    return VAR_REF_RE.sub(repl, text)


def split_words(text: str) -> list[str]:
    try:
        return shlex.split(text, posix=not sys.platform.startswith("win"))
    except ValueError:
        return text.split()


def parse_makefile(path: Path) -> tuple[dict[str, str], list[Target]]:
    variables: dict[str, str] = {}
    targets: list[Target] = []
    current: Target | None = None

    for raw in logical_lines(path.read_text(encoding="utf-8", errors="replace")):
        if raw.startswith("\t") or raw.startswith("    "):
            if current is not None:
                current.recipe.append(raw.strip())
            continue

        line = strip_comment(raw).strip()
        if not line:
            current = None
            continue

        m = ASSIGN_RE.match(line)
        if m:
            name, op, value = m.groups()
            value = value.strip()
            if op == "+=":
                variables[name] = (variables.get(name, "") + " " + value).strip()
            elif op == "?=":
                variables.setdefault(name, value)
            else:
                variables[name] = value
            current = None
            continue

        m = TARGET_RE.match(line)
        if m:
            names_text, deps_text = m.groups()
            names = split_words(expand_vars(names_text, variables))
            deps = split_words(expand_vars(deps_text, variables))
            if names:
                current = Target(names[0], deps, [])
                targets.append(current)
            continue

        current = None

    return variables, targets


def source_for_object(make_dir: Path, obj: str) -> Path | None:
    obj_path = Path(obj)
    stem = obj_path.with_suffix("")
    candidates = [
        make_dir / stem.with_suffix(".f90"),
        make_dir / stem.with_suffix(".F90"),
        make_dir / stem.with_suffix(".f"),
        make_dir / stem.with_suffix(".F"),
    ]
    for candidate in candidates:
        if candidate.exists():
            return candidate
    return None


def direct_source(make_dir: Path, dep: str) -> Path | None:
    path = make_dir / dep
    if path.suffix.lower() in {".f90", ".f", ".for", ".f95", ".f03", ".f08"} and path.exists():
        return path
    return None


def discover_programs(makefile: Path, variables: dict[str, str], targets: list[Target]) -> list[Program]:
    make_dir = makefile.parent
    executable_words = set(split_words(expand_vars(variables.get("executables", ""), variables)))
    executable_words.update(split_words(expand_vars(variables.get("EXECUTABLES", ""), variables)))
    executable_words.update(split_words(expand_vars(variables.get("EXES", ""), variables)))

    programs: list[Program] = []
    seen: set[str] = set()

    for target in targets:
        if target.name.startswith(".") or target.name in {"all", "clean", "run", "test"}:
            continue
        looks_executable = (
            target.name in executable_words
            or target.name.lower().endswith((".exe", ".out"))
            or any(tok in " ".join(target.recipe).lower() for tok in ("$(fc)", "gfortran", "ifort", "ifx", "lfortran"))
        )
        if not looks_executable:
            continue

        sources: list[Path] = []
        for dep in target.deps:
            src = direct_source(make_dir, dep)
            if src is None and Path(dep).suffix.lower() in {".o", ".obj"}:
                src = source_for_object(make_dir, dep)
            if src is not None and src not in sources:
                sources.append(src)

        if sources and target.name not in seen:
            seen.add(target.name)
            programs.append(Program(target.name, sources))

    return programs


def run_program(ofort: Path, program: Program, timeout: float | None) -> tuple[int, str, str, float, bool]:
    cmd = [str(ofort), *[str(src) for src in program.sources]]
    start = time.perf_counter()
    try:
        result = subprocess.run(cmd, text=True, capture_output=True, timeout=timeout)
        elapsed = time.perf_counter() - start
        return result.returncode, result.stdout, result.stderr, elapsed, False
    except subprocess.TimeoutExpired as exc:
        elapsed = time.perf_counter() - start
        return 1, exc.stdout or "", exc.stderr or "", elapsed, True


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Run ofort on programs inferred from executable targets in a Makefile."
    )
    parser.add_argument("makefile", help="path to Makefile")
    parser.add_argument(
        "--ofort",
        default=str(DEFAULT_OFORT),
        help=f"path to ofort executable (default: {DEFAULT_OFORT})",
    )
    parser.add_argument("--limit", type=int, metavar="N", help="try at most N programs")
    parser.add_argument(
        "--timeout",
        type=float,
        default=30.0,
        metavar="SECONDS",
        help="per-program timeout in seconds; use 0 for no timeout (default: 30)",
    )
    parser.add_argument(
        "--list",
        action="store_true",
        help="list inferred programs without running ofort",
    )
    args = parser.parse_args(argv)

    makefile = Path(args.makefile).resolve()
    ofort = Path(args.ofort).resolve()

    if args.limit is not None and args.limit < 1:
        print("--limit must be at least 1", file=sys.stderr)
        return 2
    if args.timeout < 0:
        print("--timeout must be non-negative", file=sys.stderr)
        return 2
    if not makefile.exists():
        print(f"makefile not found: {makefile}", file=sys.stderr)
        return 2
    if not ofort.exists() and not args.list:
        print(f"ofort executable not found: {ofort}", file=sys.stderr)
        return 2

    variables, targets = parse_makefile(makefile)
    programs = discover_programs(makefile, variables, targets)
    if args.limit is not None:
        programs = programs[: args.limit]
    if not programs:
        print("no executable targets with Fortran source dependencies found", file=sys.stderr)
        return 2

    print(f"makefile: {makefile}")
    print(f"programs: {len(programs)}")
    timeout = None if args.timeout == 0 else args.timeout

    failures = 0
    start_all = time.perf_counter()
    for index, program in enumerate(programs, start=1):
        rel_sources = [str(src.relative_to(makefile.parent)) for src in program.sources]
        print()
        print(f"[{index}/{len(programs)}] {program.name}")
        print("  sources: " + " ".join(rel_sources))
        if args.list:
            continue
        rc, stdout, stderr, elapsed, timed_out = run_program(ofort, program, timeout)
        status = "TIMEOUT" if timed_out else ("PASS" if rc == 0 else "FAIL")
        print(f"  {status} elapsed={elapsed:.3f}s")
        if stdout:
            print(stdout, end="")
        if stderr:
            print(stderr, end="", file=sys.stderr)
        if rc != 0:
            failures += 1

    elapsed_all = time.perf_counter() - start_all
    if args.list:
        return 0
    print()
    print(f"summary: {len(programs) - failures} passed, {failures} failed in {elapsed_all:.2f}s")
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
