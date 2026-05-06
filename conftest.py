from pathlib import Path

import pytest


ROOT = Path(__file__).resolve().parent
DEFAULT_FUJITSU_PATH = Path(
    r"C:\fortran\public_domain\github\compiler-test-suite\Fortran"
)


def pytest_addoption(parser):
    parser.addoption(
        "--fujitsu",
        action="store_true",
        default=False,
        help="run the optional Fujitsu/compiler-test-suite Fortran checks",
    )
    parser.addoption(
        "--fujitsu-path",
        action="store",
        default=str(DEFAULT_FUJITSU_PATH),
        help="path to the Fujitsu/compiler-test-suite Fortran directory",
    )
    parser.addoption(
        "--limit",
        action="store",
        type=int,
        default=None,
        help="limit optional external suite tests to the first N files",
    )


def pytest_configure(config):
    config.addinivalue_line(
        "markers",
        "fujitsu: optional Fujitsu/compiler-test-suite checks",
    )


def pytest_ignore_collect(collection_path, config):
    if config.getoption("--fujitsu"):
        return False
    return Path(collection_path).name == "test_fujitsu_suite.py"


def pytest_generate_tests(metafunc):
    if "fujitsu_source" not in metafunc.fixturenames:
        return

    if not metafunc.config.getoption("--fujitsu"):
        metafunc.parametrize("fujitsu_source", [], ids=[])
        return

    suite_path = Path(metafunc.config.getoption("--fujitsu-path"))
    if not suite_path.exists():
        metafunc.parametrize(
            "fujitsu_source",
            [
                pytest.param(
                    None,
                    marks=pytest.mark.skip(reason=f"Fujitsu suite path not found: {suite_path}"),
                    id="missing-suite",
                )
            ],
        )
        return

    files = sorted(suite_path.rglob("*.f90"))
    limit = metafunc.config.getoption("--limit")
    if limit is not None:
        if limit < 1:
            raise pytest.UsageError("--limit must be at least 1")
        files = files[:limit]

    ids = [str(path.relative_to(suite_path)).replace("\\", "/") for path in files]
    metafunc.parametrize("fujitsu_source", files, ids=ids)
