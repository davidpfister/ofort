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


def git_output(*args):
    result = subprocess.run(
        ["git", *args],
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
        text=True,
    )
    if result.returncode != 0:
        return ""
    return result.stdout.strip()


def clone_status(path):
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


def last_commit_message(path):
    git_path = str(path).replace("\\", "/")
    output = git_output("log", "-2", "--format=%s", "--", git_path)
    if not output:
        return "(none)"
    return output.splitlines()[0]


rows = sorted(
    [
        (
            str(path).replace("/", "\\"),
            path.stat().st_mtime,
            clone_status(path),
            last_commit_message(path),
        )
        for path in CORE_FILES
    ],
    key=lambda row: row[1],
    reverse=True,
)
width = max(len(name) for name, _, _, _ in rows)
status_width = max(len(status) for _, _, status, _ in rows)
message_width = max(len(message) for _, _, _, message in rows)
now = datetime.now()

print(f"{'file':<{width}}  {'modified':<16}  {'age':<10}  {'clone sees?':<{status_width}}  last commit")
print(f"{'-' * width}  {'-' * 16}  {'-' * 10}  {'-' * max(status_width, len('clone sees?'))}  {'-' * max(message_width, len('last commit'))}")

for name, mtime, status, message in rows:
    modified = datetime.fromtimestamp(mtime)
    stamp = modified.strftime("%Y-%m-%d %H:%M")
    elapsed = now - modified
    total_minutes = max(0, int(elapsed.total_seconds() // 60))
    days, rem_minutes = divmod(total_minutes, 24 * 60)
    hours, minutes = divmod(rem_minutes, 60)
    age = f"{days:02d}::{hours:02d}::{minutes:02d}"
    print(f"{name:<{width}}  {stamp}  {age}  {status:<{status_width}}  {message}")
