#!/usr/bin/env python3
"""Compare this local ofort tree against a reference GitHub checkout.

The default reference is ``C:\\github\\ofort``.  The script is intentionally
read-only: it reports files that are missing from the reference checkout and
files whose contents differ.
"""

from __future__ import annotations

import argparse
import hashlib
import re
from pathlib import Path
from typing import Iterable


DEFAULT_REPO_DIR = Path(r"C:\github\ofort")

IMPORTANT_SUFFIXES = {
    ".c",
    ".h",
    ".py",
    ".f90",
    ".f",
    ".for",
    ".md",
    ".bat",
    ".sh",
}

IMPORTANT_NAMES = {
    "makefile",
    "license",
    ".gitignore",
}

DEFAULT_EXCLUDE_DIRS = {
    ".git",
    ".pytest_cache",
    "__pycache__",
    ".mypy_cache",
    ".ruff_cache",
    "gpass_ofail",
    "gpass_ofail_next200",
    "gpass_ofail_next400",
    "gpass_ofail_next600",
    "ofort_build_check",
}

DEFAULT_EXCLUDE_NAMES = {
    "ofort.exe",
    "ofort.build",
    "a.exe",
    "a.out",
    "NUL",
    "temp.txt",
}


def normalized_rel(path: Path, root: Path) -> str:
    return path.relative_to(root).as_posix()


def is_tempish_name(name: str) -> bool:
    n = name.lower()
    return (
        n.startswith("_")
        or n.startswith("tmp")
        or n.startswith("temp")
        or n.startswith("xdbg")
        or "scratch" in n
        or n.endswith(".tmp")
    )


def is_important_file(path: Path) -> bool:
    name = path.name.lower()
    return path.suffix.lower() in IMPORTANT_SUFFIXES or name in IMPORTANT_NAMES


def should_skip(path: Path, root: Path, *, notemp: bool) -> bool:
    rel_parts = path.relative_to(root).parts
    lower_parts = [p.lower() for p in rel_parts]
    rel = path.relative_to(root).as_posix().lower()
    if any(part in DEFAULT_EXCLUDE_DIRS for part in lower_parts[:-1]):
        return True
    if any(part.startswith("__pytest_tmp") for part in lower_parts[:-1]):
        return True
    if path.name in DEFAULT_EXCLUDE_NAMES or path.name.lower() in DEFAULT_EXCLUDE_NAMES:
        return True
    if notemp and is_tempish_name(path.name):
        return True
    if notemp and len(rel_parts) == 1 and path.suffix.lower() in {".f90", ".f", ".for"}:
        return True
    if notemp and (
        rel.startswith("fujitsu_")
        or rel.startswith("xtmp_")
        or rel.startswith("results_")
        or rel.endswith("_results.txt")
        or rel.endswith("_summary.txt")
    ):
        return True
    return False


def list_project_files(root: Path, *, notemp: bool) -> dict[str, Path]:
    out: dict[str, Path] = {}
    for path in sorted(root.rglob("*"), key=lambda p: normalized_rel(p, root).lower()):
        if not path.is_file():
            continue
        if should_skip(path, root, notemp=notemp):
            continue
        if not is_important_file(path):
            continue
        out[normalized_rel(path, root).lower()] = path
    return out


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def normalized_text(path: Path) -> str:
    text = path.read_text(encoding="utf-8", errors="ignore")
    text = text.replace("\r\n", "\n").replace("\r", "\n")
    if text.startswith("\ufeff"):
        text = text[1:]
    return text


def files_differ(local_path: Path, repo_path: Path, *, mode: str) -> bool:
    if mode == "bytes":
        return sha256_file(local_path) != sha256_file(repo_path)
    return normalized_text(local_path) != normalized_text(repo_path)


def file_contains_all(path: Path, needles: list[str]) -> bool:
    if not needles:
        return True
    text = normalized_text(path).lower()
    return all(needle.lower() in text for needle in needles)


def print_list(title: str, items: Iterable[str], *, flat: bool = False) -> None:
    vals = sorted(set(items), key=str.lower)
    print(title)
    if flat:
        print("(none)" if not vals else " ".join(f'"{v}"' for v in vals))
        return
    if not vals:
        print("  (none)")
        return
    for item in vals:
        print(f"  {item}")


def category(rel: str) -> str:
    p = Path(rel)
    suffix = p.suffix.lower()
    first = p.parts[0].lower() if p.parts else ""
    if suffix in {".c", ".h"}:
        return "C source/header"
    if suffix == ".py":
        return "Python"
    if first == "tests" or suffix in {".f90", ".f", ".for"}:
        return "Fortran/tests"
    if suffix in {".md", ".txt"}:
        return "docs/text"
    if suffix in {".bat", ".sh"} or p.name.lower() == "makefile":
        return "build/scripts"
    return "other"


def grouped(items: Iterable[str]) -> dict[str, list[str]]:
    groups: dict[str, list[str]] = {}
    for item in items:
        groups.setdefault(category(item), []).append(item)
    return groups


def print_grouped(title: str, items: Iterable[str], *, flat: bool = False) -> None:
    print(title)
    groups = grouped(items)
    if not groups:
        print("(none)" if flat else "  (none)")
        return
    for group in sorted(groups):
        vals = sorted(groups[group], key=str.lower)
        if flat:
            print(f"{group}: " + " ".join(f'"{v}"' for v in vals))
        else:
            print(f"  {group}:")
            for val in vals:
                print(f"    {val}")


def mentioned_names(readme_path: Path) -> set[str]:
    if not readme_path.exists():
        return set()
    text = readme_path.read_text(encoding="utf-8", errors="ignore")
    names: set[str] = set()
    for match in re.finditer(
        r"\b([A-Za-z0-9_.\-/]+(?:\.c|\.h|\.py|\.f90|\.f|\.for|\.md|\.txt|\.bat|\.sh))\b",
        text,
        flags=re.IGNORECASE,
    ):
        names.add(match.group(1).replace("\\", "/").lower())
    return names


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Compare local ofort project files with a reference GitHub checkout."
    )
    parser.add_argument(
        "--local-dir",
        type=Path,
        default=Path("."),
        help="Local ofort directory (default: current directory)",
    )
    parser.add_argument(
        "--repo-dir",
        type=Path,
        default=DEFAULT_REPO_DIR,
        help=rf"Reference checkout directory (default: {DEFAULT_REPO_DIR})",
    )
    parser.add_argument(
        "--compare-mode",
        choices=["text", "bytes"],
        default="text",
        help="Comparison mode for differing files (default: text)",
    )
    parser.add_argument("--flat", action="store_true", help="Print compact one-line lists")
    parser.add_argument("--notemp", action="store_true", help="Suppress obvious temp/scratch files")
    parser.add_argument(
        "--contains",
        action="append",
        default=[],
        help="Keep only local files containing this substring. Repeatable.",
    )
    args = parser.parse_args()

    local_dir = args.local_dir.resolve()
    repo_dir = args.repo_dir.resolve()
    if not local_dir.is_dir():
        print(f"Local directory not found: {local_dir}")
        return 2
    if not repo_dir.is_dir():
        print(f"Repo directory not found: {repo_dir}")
        return 2

    local_files = list_project_files(local_dir, notemp=args.notemp)
    repo_files = list_project_files(repo_dir, notemp=args.notemp)
    if args.contains:
        local_files = {
            rel: path
            for rel, path in local_files.items()
            if file_contains_all(path, args.contains)
        }

    local_names = set(local_files)
    repo_names = set(repo_files)
    readme_names = mentioned_names(repo_dir / "README.md")

    missing_from_repo = sorted(local_names - repo_names)
    missing_from_readme = sorted(
        rel for rel in local_names if Path(rel).name.lower() not in readme_names and rel not in readme_names
    )
    differs = sorted(
        rel
        for rel in local_names & repo_names
        if files_differ(local_files[rel], repo_files[rel], mode=args.compare_mode)
    )

    print(f"Local directory: {local_dir}")
    print(f"Repo directory:  {repo_dir}")
    print(f"Compare mode:    {args.compare_mode}")
    if args.contains:
        print(f"Contains filter: {args.contains}")
    print("")
    print(f"Local files considered: {len(local_names)}")
    print(f"Repo files considered:  {len(repo_names)}")
    print("")
    print_grouped("Local important files missing from reference checkout:", missing_from_repo, flat=args.flat)
    print("")
    print_grouped("Local important files differing from reference checkout:", differs, flat=args.flat)
    print("")
    print_grouped("Local important files not mentioned in reference README:", missing_from_readme, flat=args.flat)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
