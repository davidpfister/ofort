#!/usr/bin/env python3
"""Small cross-platform GUI front end for ofort.

This is intentionally a thin wrapper around the command-line executable. It
does not import or modify the C interpreter; it writes the editor contents to a
temporary .f90 file, runs ofort, and displays stdout/stderr.
"""

from __future__ import annotations

import os
import re
import shutil
import subprocess
import sys
import tempfile
import tkinter as tk
from pathlib import Path
from tkinter import filedialog, messagebox, ttk


APP_TITLE = "ofort GUI"
DEFAULT_SOURCE = """program main
  integer :: n
  n = 2**5
  print *, n
end program main
"""


def default_ofort_path() -> str:
    script_dir = Path(__file__).resolve().parent
    names = ["ofort.exe"] if os.name == "nt" else ["ofort", "ofort.exe"]
    for name in names:
        candidate = script_dir / name
        if candidate.exists():
            return str(candidate)
    found = shutil.which("ofort.exe" if os.name == "nt" else "ofort")
    return found or ("ofort.exe" if os.name == "nt" else "ofort")


class OfortGui(tk.Tk):
    def __init__(self) -> None:
        super().__init__()
        self.title(APP_TITLE)
        self.geometry("1100x760")
        self.minsize(780, 520)

        self.current_file: Path | None = None
        self.ofort_path = tk.StringVar(value=default_ofort_path())
        self.trace_assign = tk.BooleanVar(value=False)
        self.no_implicit = tk.BooleanVar(value=False)
        self.std_f2023 = tk.BooleanVar(value=False)
        self.fast = tk.BooleanVar(value=False)
        self.status = tk.StringVar(value="Ready")

        self._build_ui()
        self.editor.insert("1.0", DEFAULT_SOURCE)

    def _build_ui(self) -> None:
        self.columnconfigure(0, weight=1)
        self.rowconfigure(1, weight=1)

        toolbar = ttk.Frame(self, padding=(8, 8, 8, 4))
        toolbar.grid(row=0, column=0, sticky="ew")
        toolbar.columnconfigure(1, weight=1)

        ttk.Label(toolbar, text="ofort").grid(row=0, column=0, sticky="w")
        ttk.Entry(toolbar, textvariable=self.ofort_path).grid(row=0, column=1, sticky="ew", padx=6)
        ttk.Button(toolbar, text="Browse", command=self.browse_ofort).grid(row=0, column=2, padx=(0, 8))
        ttk.Button(toolbar, text="Open", command=self.open_file).grid(row=0, column=3)
        ttk.Button(toolbar, text="Save", command=self.save_file).grid(row=0, column=4, padx=(4, 0))
        ttk.Button(toolbar, text="Run", command=self.run_source).grid(row=0, column=5, padx=(12, 0))
        ttk.Button(toolbar, text="Clear Output", command=self.clear_output).grid(row=0, column=6, padx=(4, 0))

        options = ttk.Frame(toolbar)
        options.grid(row=1, column=0, columnspan=6, sticky="w", pady=(8, 0))
        ttk.Checkbutton(options, text="--trace-assign", variable=self.trace_assign).grid(row=0, column=0)
        ttk.Checkbutton(options, text="--no-implicit-typing", variable=self.no_implicit).grid(row=0, column=1, padx=12)
        ttk.Checkbutton(options, text="--std=f2023", variable=self.std_f2023).grid(row=0, column=2)
        ttk.Checkbutton(options, text="--fast", variable=self.fast).grid(row=0, column=3, padx=12)

        paned = ttk.PanedWindow(self, orient=tk.VERTICAL)
        paned.grid(row=1, column=0, sticky="nsew", padx=8, pady=4)

        editor_frame = ttk.Frame(paned)
        editor_frame.columnconfigure(0, weight=1)
        editor_frame.rowconfigure(0, weight=1)
        self.editor = tk.Text(editor_frame, undo=True, wrap="none", font=("Consolas", 11))
        self.editor.configure(
            background="#fbfaf7",
            foreground="#1f2933",
            insertbackground="#1f2933",
            selectbackground="#cfe8ff",
        )
        editor_y = ttk.Scrollbar(editor_frame, orient="vertical", command=self.editor.yview)
        editor_x = ttk.Scrollbar(editor_frame, orient="horizontal", command=self.editor.xview)
        self.editor.configure(yscrollcommand=editor_y.set, xscrollcommand=editor_x.set)
        self.editor.grid(row=0, column=0, sticky="nsew")
        editor_y.grid(row=0, column=1, sticky="ns")
        editor_x.grid(row=1, column=0, sticky="ew")
        self.editor.bind("<Return>", self.on_editor_return)
        self.editor.bind("<KeyRelease>", self.on_editor_key_release, add="+")
        self.configure_syntax_tags()
        paned.add(editor_frame, weight=3)

        output_frame = ttk.Notebook(paned)
        self.stdout = self._output_text(output_frame, "stdout")
        self.stderr = self._output_text(output_frame, "stderr")
        self.assignments = self._output_text(output_frame, "assignments")
        self.problems = self._problems_table(output_frame)
        paned.add(output_frame, weight=2)

        status = ttk.Label(self, textvariable=self.status, anchor="w", padding=(8, 4))
        status.grid(row=2, column=0, sticky="ew")

        self.bind("<Control-o>", lambda _event: self.open_file())
        self.bind("<Control-s>", lambda _event: self.save_file())
        self.bind("<F5>", lambda _event: self.run_source())

    def configure_syntax_tags(self) -> None:
        self.editor.tag_configure("keyword", foreground="#175cd3", font=("Consolas", 11, "bold"))
        self.editor.tag_configure("typekw", foreground="#047481", font=("Consolas", 11, "bold"))
        self.editor.tag_configure("intrinsic", foreground="#7a4cc2")
        self.editor.tag_configure("string", foreground="#a44712")
        self.editor.tag_configure("comment", foreground="#667085", font=("Consolas", 11, "italic"))
        self.editor.tag_configure("number", foreground="#9a3412")
        self.editor.tag_configure("problem_line", background="#fff1c2")

    def on_editor_key_release(self, _event: tk.Event) -> None:
        self.after_idle(self.highlight_syntax)

    def highlight_syntax(self) -> None:
        text = self.editor.get("1.0", "end-1c")
        for tag in ("keyword", "typekw", "intrinsic", "string", "comment", "number"):
            self.editor.tag_remove(tag, "1.0", "end")

        keyword_re = re.compile(
            r"\b(program|module|contains|subroutine|function|end|if|then|else|elseif|do|while|select|case|where|forall|associate|block|call|return|stop|exit|cycle|allocate|deallocate|use|implicit|none|parameter|common|data|save|public|private|interface|procedure|class|extends|print|write|read|open|close|format)\b",
            re.IGNORECASE,
        )
        type_re = re.compile(
            r"\b(integer|real|double\s+precision|complex|logical|character|type|kind|len|dimension|allocatable|pointer|target|intent|optional|value|parameter)\b",
            re.IGNORECASE,
        )
        intrinsic_re = re.compile(
            r"\b(abs|sin|cos|tan|sqrt|exp|log|max|min|sum|product|size|shape|len|trim|adjustl|adjustr|allocated|associated|present|real|int|nint|cmplx|mod|merge)\b",
            re.IGNORECASE,
        )
        number_re = re.compile(r"(?<![\w.])(?:\d+(?:\.\d*)?|\.\d+)(?:[ed][+-]?\d+)?(?:_\w+)?", re.IGNORECASE)
        string_re = re.compile(r"'(?:''|[^'])*'|\"(?:\"\"|[^\"])*\"")

        for line_no, line in enumerate(text.splitlines(), start=1):
            comment_at = self.comment_start(line)
            code_part = line if comment_at is None else line[:comment_at]

            for match in string_re.finditer(code_part):
                self.tag_match("string", line_no, match)

            masked = string_re.sub(lambda m: " " * (m.end() - m.start()), code_part)
            for tag, regex in (
                ("keyword", keyword_re),
                ("typekw", type_re),
                ("intrinsic", intrinsic_re),
                ("number", number_re),
            ):
                for match in regex.finditer(masked):
                    self.tag_match(tag, line_no, match)

            if comment_at is not None:
                self.editor.tag_add("comment", f"{line_no}.{comment_at}", f"{line_no}.end")

    def tag_match(self, tag: str, line_no: int, match: re.Match[str]) -> None:
        self.editor.tag_add(tag, f"{line_no}.{match.start()}", f"{line_no}.{match.end()}")

    @staticmethod
    def comment_start(line: str) -> int | None:
        quote: str | None = None
        i = 0
        while i < len(line):
            ch = line[i]
            if quote:
                if ch == quote:
                    if i + 1 < len(line) and line[i + 1] == quote:
                        i += 2
                        continue
                    quote = None
            elif ch in ("'", '"'):
                quote = ch
            elif ch == "!":
                return i
            i += 1
        return None

    def on_editor_return(self, _event: tk.Event) -> None:
        current_line_index = self.editor.index("insert linestart")
        current_line = self.editor.get(current_line_index, "insert lineend")
        indent = self.next_indent(current_line)
        self.dedent_current_line_if_needed(current_line_index, current_line)
        self.editor.insert("insert", "\n" + indent)
        if self.trace_assign.get():
            self.after_idle(self.run_source)
        return "break"

    def dedent_current_line_if_needed(self, line_index: str, line: str) -> None:
        stripped = line.strip().lower()
        if not re.match(r"^(end\s*(if|do|select|where|forall|associate|block|type|interface|module|program|subroutine|function)\b|else\b|else\s*if\b|case\b)", stripped):
            return
        leading = re.match(r"^[ \t]*", line).group(0)
        if leading.endswith("    "):
            self.editor.delete(line_index, f"{line_index}+4c")

    @staticmethod
    def next_indent(previous_line: str) -> str:
        base = re.match(r"^[ \t]*", previous_line).group(0)
        text = previous_line.strip().lower()

        if re.match(r"^(end\s*(if|do|select|where|forall|associate|block|type|interface|module|program|subroutine|function)\b|else\b|else\s*if\b|case\b)", text):
            base = base[:-4] if base.endswith("    ") else base

        if (
            re.search(r"\bthen\s*$", text)
            or re.match(r"^(do|select\s+case|select\s+type|where|forall|associate|block)\b", text)
            or re.match(r"^(else|else\s*if|case)\b", text)
        ):
            base += "    "

        return base

    def _output_text(self, notebook: ttk.Notebook, label: str) -> tk.Text:
        frame = ttk.Frame(notebook)
        frame.columnconfigure(0, weight=1)
        frame.rowconfigure(0, weight=1)
        text = tk.Text(frame, wrap="word", font=("Consolas", 10), height=10)
        scroll = ttk.Scrollbar(frame, orient="vertical", command=text.yview)
        text.configure(yscrollcommand=scroll.set)
        text.grid(row=0, column=0, sticky="nsew")
        scroll.grid(row=0, column=1, sticky="ns")
        notebook.add(frame, text=label)
        return text

    def _problems_table(self, notebook: ttk.Notebook) -> ttk.Treeview:
        frame = ttk.Frame(notebook)
        frame.columnconfigure(0, weight=1)
        frame.rowconfigure(0, weight=1)
        table = ttk.Treeview(frame, columns=("line", "message"), show="headings", selectmode="browse")
        table.heading("line", text="Line")
        table.heading("message", text="Message")
        table.column("line", width=70, stretch=False, anchor="e")
        table.column("message", width=720, stretch=True)
        scroll = ttk.Scrollbar(frame, orient="vertical", command=table.yview)
        table.configure(yscrollcommand=scroll.set)
        table.grid(row=0, column=0, sticky="nsew")
        scroll.grid(row=0, column=1, sticky="ns")
        table.bind("<Double-1>", self.goto_selected_problem)
        table.bind("<Return>", self.goto_selected_problem)
        notebook.add(frame, text="problems")
        return table

    def clear_output(self) -> None:
        self.stdout.delete("1.0", "end")
        self.stderr.delete("1.0", "end")
        self.assignments.delete("1.0", "end")
        for item in self.problems.get_children():
            self.problems.delete(item)
        self.editor.tag_remove("problem_line", "1.0", "end")
        self.status.set("Output cleared")

    def goto_selected_problem(self, _event: tk.Event | None = None) -> None:
        selection = self.problems.selection()
        if not selection:
            return
        line_text = self.problems.set(selection[0], "line")
        try:
            line_no = int(line_text)
        except ValueError:
            return
        self.editor.tag_remove("problem_line", "1.0", "end")
        self.editor.tag_add("problem_line", f"{line_no}.0", f"{line_no}.end")
        self.editor.mark_set("insert", f"{line_no}.0")
        self.editor.see(f"{line_no}.0")
        self.editor.focus_set()

    def browse_ofort(self) -> None:
        path = filedialog.askopenfilename(title="Select ofort executable")
        if path:
            self.ofort_path.set(path)

    def open_file(self) -> None:
        path = filedialog.askopenfilename(
            title="Open Fortran source",
            filetypes=[("Fortran source", "*.f90 *.F90 *.f *.for"), ("All files", "*.*")],
        )
        if not path:
            return
        source_path = Path(path)
        try:
            text = source_path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            text = source_path.read_text()
        except OSError as exc:
            messagebox.showerror(APP_TITLE, f"Could not open file:\n{exc}")
            return
        self.current_file = source_path
        self.editor.delete("1.0", "end")
        self.editor.insert("1.0", text)
        self.highlight_syntax()
        self.status.set(f"Opened {source_path}")

    def save_file(self) -> None:
        if self.current_file is None:
            path = filedialog.asksaveasfilename(
                title="Save Fortran source",
                defaultextension=".f90",
                filetypes=[("Fortran source", "*.f90"), ("All files", "*.*")],
            )
            if not path:
                return
            self.current_file = Path(path)
        try:
            self.current_file.write_text(self.editor.get("1.0", "end-1c"), encoding="utf-8")
        except OSError as exc:
            messagebox.showerror(APP_TITLE, f"Could not save file:\n{exc}")
            return
        self.status.set(f"Saved {self.current_file}")

    def command_args(self, source_path: Path) -> list[str]:
        args = [self.ofort_path.get()]
        if self.trace_assign.get():
            args.append("--trace-assign")
        if self.no_implicit.get():
            args.append("--no-implicit-typing")
        if self.std_f2023.get():
            args.append("--std=f2023")
        if self.fast.get():
            args.append("--fast")
        args.append(str(source_path))
        return args

    def run_source(self) -> None:
        self.stdout.delete("1.0", "end")
        self.stderr.delete("1.0", "end")
        self.assignments.delete("1.0", "end")
        for item in self.problems.get_children():
            self.problems.delete(item)
        self.editor.tag_remove("problem_line", "1.0", "end")
        source = self.editor.get("1.0", "end-1c")

        with tempfile.TemporaryDirectory(prefix="ofort_gui_") as tmp:
            source_path = Path(tmp) / "input.f90"
            source_path.write_text(source, encoding="utf-8")
            try:
                result = subprocess.run(
                    self.command_args(source_path),
                    cwd=Path(__file__).resolve().parent,
                    text=True,
                    capture_output=True,
                    timeout=30,
                )
            except FileNotFoundError:
                messagebox.showerror(APP_TITLE, f"Could not find executable:\n{self.ofort_path.get()}")
                self.status.set("Run failed")
                return
            except subprocess.TimeoutExpired:
                messagebox.showerror(APP_TITLE, "ofort timed out after 30 seconds")
                self.status.set("Run timed out")
                return

        self.stdout.insert("1.0", result.stdout)
        self.stderr.insert("1.0", result.stderr)
        if self.trace_assign.get():
            values = [line for line in (result.stderr + result.stdout).splitlines() if line.strip()]
            if values:
                self.assignments.insert(
                    "1.0",
                    "\n".join(f"{index + 1}: {value}" for index, value in enumerate(values)) + "\n",
                )
        self.populate_problems(result.stderr)
        self.status.set(f"Exit code {result.returncode}")

    def populate_problems(self, stderr: str) -> None:
        seen: set[tuple[int, str]] = set()
        for raw_line in stderr.splitlines():
            line = raw_line.strip()
            if not line:
                continue
            parsed = self.parse_problem_line(line)
            if not parsed:
                continue
            line_no, message = parsed
            key = (line_no, message)
            if key in seen:
                continue
            seen.add(key)
            self.problems.insert("", "end", values=(line_no, message))
        children = self.problems.get_children()
        if children:
            self.problems.selection_set(children[0])

    @staticmethod
    def parse_problem_line(line: str) -> tuple[int, str] | None:
        match = re.match(r"^.*?:(\d+):\s*(.+)$", line)
        if match:
            return int(match.group(1)), match.group(2)

        match = re.search(r"\bat line\s+(\d+):\s*(.+)$", line, re.IGNORECASE)
        if match:
            return int(match.group(1)), line

        match = re.match(r"^line\s+(\d+):\s*(.+)$", line, re.IGNORECASE)
        if match:
            return int(match.group(1)), match.group(2)

        return None


def main() -> int:
    app = OfortGui()
    app.mainloop()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
