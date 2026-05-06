@echo off
rem Local Windows clone/build/test sanity check for this working copy.
rem This script is intentionally machine- and cmd.exe-oriented; it is not
rem required for normal portable builds. It clones the committed HEAD into
rem ofort_build_check, then runs "make gcc" and "pytest -q" there, so it
rem catches files that were edited locally but not committed.
setlocal

cd /d "%~dp0" || exit /b 1
set "checkdir=ofort_build_check"

git diff --quiet
if errorlevel 1 (
    echo gitcheck.bat clones committed HEAD, but the working tree has uncommitted tracked changes.
    echo Commit or revert tracked changes before running this clone check.
    exit /b 1
)

git diff --cached --quiet
if errorlevel 1 (
    echo gitcheck.bat clones committed HEAD, but the index has staged changes.
    echo Commit staged changes before running this clone check.
    exit /b 1
)

for %%F in (Makefile include/ofort.h src/main.c src/ofort.c src/ofort_internal.h src/ofort_values.c) do (
    git ls-files --error-unmatch "%%F" >nul 2>nul
    if errorlevel 1 (
        echo Required build file is not tracked by git: %%F
        echo Add it before running this clone check:
        echo   git add %%F
        exit /b 1
    )
    git cat-file -e "HEAD:%%F" >nul 2>nul
    if errorlevel 1 (
        echo Required build file is not committed yet: %%F
        echo gitcheck.bat clones HEAD, not the staged index or working tree.
        echo Commit the build files before running this clone check.
        exit /b 1
    )
    git diff --quiet -- "%%F"
    if errorlevel 1 (
        echo Required build file has uncommitted working-tree changes: %%F
        echo gitcheck.bat clones HEAD, so commit this change before running the clone check.
        exit /b 1
    )
    git diff --cached --quiet -- "%%F"
    if errorlevel 1 (
        echo Required build file has staged but uncommitted changes: %%F
        echo gitcheck.bat clones HEAD, so commit this change before running the clone check.
        exit /b 1
    )
)

if exist "%checkdir%" rmdir /s /q "%checkdir%" || exit /b 1
git clone "%CD%" "%checkdir%" || exit /b 1
pushd "%checkdir%" || exit /b 1
make gcc || exit /b 1
pytest -q || exit /b 1
popd

endlocal
:: python scripts\bench_sizes.py 1000000 5000000 50000000 --ofort-fast --gfortran --ifx --run-only --no-list
