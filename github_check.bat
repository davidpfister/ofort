@echo off
setlocal

set "repo=https://github.com/beliavsky/ofort.git"
set "dir=C:\github\ofort"
set "run_interop=%OFORT_CHECK_INTEROP%"
if "%run_interop%"=="" set "run_interop=0"

:parse_args
if "%~1"=="" goto args_done
if /i "%~1"=="--interop" (
    set "run_interop=1"
    shift
    goto parse_args
)
if /i "%~1"=="--no-interop" (
    set "run_interop=0"
    shift
    goto parse_args
)
set "dir=%~1"
shift
goto parse_args
:args_done

for %%D in ("%dir%") do set "root=%%~dpD"
if not exist "%root%" mkdir "%root%" || exit /b 1

if exist "%dir%\.git" (
    cd /d "%dir%" || exit /b 1
    git pull --ff-only || exit /b 1
) else (
    if exist "%dir%" (
        echo Target exists but is not a git repo: "%dir%"
        exit /b 1
    )
    git clone "%repo%" "%dir%" || exit /b 1
    cd /d "%dir%" || exit /b 1
)

make gcc || exit /b 1
pytest -q || exit /b 1

if "%run_interop%"=="1" (
    where gfortran >NUL 2>NUL || (
        echo --interop requested, but gfortran was not found on PATH.
        exit /b 1
    )
    make -f bindings\fortran\makefile clean || exit /b 1
    make -f bindings\fortran\makefile || exit /b 1
    bindings\fortran\demo_eval.exe || exit /b 1
) else (
    echo Skipping Fortran interop demo. Use --interop or set OFORT_CHECK_INTEROP=1 to run it.
)

endlocal
