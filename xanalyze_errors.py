r"""
File format:
  <filepath>:
  <error message(s)>
  line N: <source code>   (optional context line)
  <blank line>

Generating a results file:
  Results files are usually made by running ofort over a source manifest or
  glob and redirecting both stdout and stderr to a text file:

    .\ofort.exe --each --check "@suite_files.txt" > suite_results.txt 2>&1
    .\ofort.exe --each --check "tests\cases\x*.f90" > suite_results.txt 2>&1

  The @list form is useful because related tools can recover the original
  file list from the command line saved at the top of the results file.

Usage:
  python xanalyze_errors.py [results_file] [--top N] [--examples N] [--all]

  results_file   results text file to analyze (default: newest *results*.txt)
  --top N       show top N error types (default 30)
  --examples N  show N example files per error type (default 5, 0 = none)
  --all         dump every distinct normalized error type at the end
  --quiet       write only to the summary file, not the terminal
"""

import glob
import os
import re
import sys
from collections import Counter

RESULTS_FILE = None
TOP_N = 30
EXAMPLES_N = 5


class Tee:
    def __init__(self, *streams):
        self.streams = streams

    def write(self, text):
        for stream in self.streams:
            try:
                stream.write(text)
            except UnicodeEncodeError:
                encoding = getattr(stream, "encoding", None) or "utf-8"
                safe_text = text.encode(encoding, errors="replace").decode(encoding)
                stream.write(safe_text)
        return len(text)

    def flush(self):
        for stream in self.streams:
            stream.flush()


def summary_file_for(results_file):
    dirname, basename = os.path.split(results_file)
    summary_name, n = re.subn("results", "summary", basename, count=1, flags=re.IGNORECASE)
    if n == 0:
        root, ext = os.path.splitext(basename)
        summary_name = root + "_summary" + ext
    return os.path.join(dirname, summary_name)


def normalize(msg):
    """Strip line numbers and literal tokens so similar errors group together."""
    # "Syntax error at line 42: ..." -> "Syntax error: ..."
    msg = re.sub(r" at line \d+", "", msg)
    # "Unexpected character 'X' (0xNN) at line N" -> strip hex code and line
    msg = re.sub(r" \(0x[0-9a-fA-F]+\)", "", msg)
    # "Invalid assignment target at line N" -> already handled above
    # Collapse runs of whitespace
    msg = " ".join(msg.split())
    return msg


def is_filepath(line):
    return bool(re.match(r"[a-zA-Z]:\\.*\.(f90|F90|f|F|for|FOR):", line.strip()))


def is_source_context(line):
    return bool(re.match(r"\s*line \d+:", line))


def is_command_line(line):
    """Skip the initial timethis/ofort invocation line."""
    return "timethis" in line or line.strip().startswith("c:\\c\\ofort>")


def collect_errors(path):
    errors = []          # (normalized_msg, raw_msg, filepath, source_context)
    files_seen = set()
    files_analyzed = None
    current_file = None
    pending_msgs = []
    last_source = None

    def flush():
        for raw in pending_msgs:
            norm = normalize(raw)
            errors.append((norm, raw, current_file, last_source))

    with open(path, encoding="utf-8", errors="replace") as fh:
        for line in fh:
            line = line.rstrip("\n")
            stripped = line.strip()

            if not stripped:
                flush()
                pending_msgs = []
                last_source = None
                continue

            if is_command_line(stripped):
                continue

            m = re.match(r"checked\s+(\d+)\s+files:", stripped, re.IGNORECASE)
            if m:
                files_analyzed = int(m.group(1))
                continue

            if is_filepath(stripped):
                flush()
                pending_msgs = []
                last_source = None
                current_file = stripped.rstrip(":")
                files_seen.add(current_file)
                continue

            if is_source_context(line):
                last_source = stripped
                continue

            # It's an error message
            pending_msgs.append(stripped)

    flush()
    if files_analyzed is None:
        files_analyzed = len(files_seen)
    return errors, files_analyzed


def default_results_file():
    matches = glob.glob("*results*.txt")
    if not matches:
        raise SystemExit("no results file specified and no *results*.txt files found")
    return max(matches, key=os.path.getmtime)


def parse_args():
    args = sys.argv[1:]
    results_file = None
    top_n = TOP_N
    examples_n = EXAMPLES_N
    show_all = False
    quiet = False
    i = 0
    while i < len(args):
        if args[i] in ("--help", "-h"):
            print(__doc__.strip())
            raise SystemExit(0)
        elif args[i] == "--top" and i + 1 < len(args):
            top_n = int(args[i + 1]); i += 2
        elif args[i] == "--examples" and i + 1 < len(args):
            examples_n = int(args[i + 1]); i += 2
        elif args[i] == "--all":
            show_all = True; i += 1
        elif args[i] == "--quiet":
            quiet = True; i += 1
        elif args[i].startswith("--"):
            raise SystemExit(f"unknown option: {args[i]}")
        elif results_file is None:
            results_file = args[i]; i += 1
        else:
            raise SystemExit(f"unexpected argument: {args[i]}")
    if results_file is None:
        results_file = default_results_file()
    return results_file, top_n, examples_n, show_all, quiet


def main():
    results_file, top_n, examples_n, show_all, quiet = parse_args()
    summary_file = summary_file_for(results_file)
    original_stdout = sys.stdout
    summary_fh = open(summary_file, "w", encoding="utf-8")
    sys.stdout = summary_fh if quiet else Tee(original_stdout, summary_fh)
    try:
        run_analysis(results_file, top_n, examples_n, show_all)
        print()
        message = f"{results_file} summarized in {summary_file}"
        print(message)
        if quiet:
            original_stdout.write(message + "\n")
            original_stdout.flush()
    finally:
        sys.stdout = original_stdout
        summary_fh.close()


def run_analysis(results_file, top_n, examples_n, show_all):
    print(results_file)
    errors, files_analyzed = collect_errors(results_file)
    total_files_affected = len({fp for _, _, fp, _ in errors})
    total_errors = len(errors)

    norm_counter = Counter(norm for norm, _, _, _ in errors)

    # Collect up to examples_n (file, raw_msg, source_context) per error type
    examples_per_error = {}
    for norm, raw, fp, src in errors:
        bucket = examples_per_error.setdefault(norm, [])
        if len(bucket) < examples_n:
            bucket.append((fp, raw, src))

    files_per_error = {}
    for norm, _, fp, _ in errors:
        files_per_error.setdefault(norm, set()).add(fp)

    print(f"Files analyzed          : {files_analyzed}")
    print(f"Total error occurrences : {total_errors}")
    print(f"Distinct error types    : {len(norm_counter)}")
    print(f"Files with errors       : {total_files_affected}")

    for rank, (norm, count) in enumerate(norm_counter.most_common(top_n), 1):
        file_count = len(files_per_error[norm])
        print()
        print(f"{'='*90}")
        print(f"#{rank}  [{count} occurrences, {file_count} files]  {norm}")
        if examples_n > 0:
            examples = examples_per_error.get(norm, [])
            dirs = [os.path.dirname(fp) for fp, _, _ in examples]
            stem = os.path.commonpath(dirs) if dirs else ""
            # Only factor out a stem that is more specific than a bare drive root
            use_stem = stem and len(stem) > 3
            if use_stem:
                print(f"  [{stem}]")
            for fp, raw, src in examples:
                label = os.path.relpath(fp, stem) if use_stem else fp
                if src:
                    m = re.match(r"line (\d+):\s*(.*)", src)
                    if m:
                        print(f"  {label}:{m.group(1)}: {m.group(2)}")
                    else:
                        print(f"  {label}: {src}")
                else:
                    print(f"  {label}")

    if show_all:
        print()
        print("All distinct error types (sorted by count):")
        for norm, count in norm_counter.most_common():
            print(f"  {count:>6}  {norm}")


if __name__ == "__main__":
    main()
