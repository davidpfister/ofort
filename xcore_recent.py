from pathlib import Path
from datetime import datetime
import subprocess

CORE_FILES = [
    Path("Makefile"),
    Path("include/ofort.h"),
    Path("src/main.c"),
    Path("src/ofort.c"),
    Path("src/ofort_internal.h"),
    Path("src/ofort_values.c"),
]


def git_ok(*args):
    return subprocess.run(
        ["git", *args],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    ).returncode == 0


def clone_status(path):
    name = str(path).replace("/", "\\")
    git_path = str(path).replace("\\", "/")
    if not path.exists():
        return "no: missing"
    if not git_ok("ls-files", "--error-unmatch", git_path):
        return "no: untracked"
    if not git_ok("cat-file", "-e", f"HEAD:{git_path}"):
        return "no: not in HEAD"
    if not git_ok("diff", "--quiet", "--", git_path):
        return "no: modified"
    if not git_ok("diff", "--cached", "--quiet", "--", git_path):
        return "no: staged"
    return "yes"


rows = sorted(
    [
        (str(path).replace("/", "\\"), path.stat().st_mtime, clone_status(path))
        for path in CORE_FILES
    ],
    key=lambda row: row[1],
    reverse=True,
)
width = max(len(name) for name, _, _ in rows)
status_width = max(len(status) for _, _, status in rows)
now = datetime.now()

print(f"{'file':<{width}}  {'modified':<16}  {'age':<10}  {'clone sees?':<{status_width}}")
print(f"{'-' * width}  {'-' * 16}  {'-' * 10}  {'-' * max(status_width, len('clone sees?'))}")

for name, mtime, status in rows:
    modified = datetime.fromtimestamp(mtime)
    stamp = modified.strftime("%Y-%m-%d %H:%M")
    elapsed = now - modified
    total_minutes = max(0, int(elapsed.total_seconds() // 60))
    days, rem_minutes = divmod(total_minutes, 24 * 60)
    hours, minutes = divmod(rem_minutes, 60)
    age = f"{days:02d}::{hours:02d}::{minutes:02d}"
    print(f"{name:<{width}}  {stamp}  {age}  {status:<{status_width}}")
