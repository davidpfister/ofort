import subprocess
from pathlib import Path

import pytest


ROOT = Path(__file__).resolve().parents[1]
OFORT = ROOT / "ofort.exe"


pytestmark = pytest.mark.fujitsu


@pytest.fixture(scope="session")
def fujitsu_ofort():
    result = subprocess.run(
        ["make"],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=30,
    )
    assert result.returncode == 0, result.stdout + result.stderr
    assert OFORT.exists()
    return OFORT


def test_fujitsu_check(fujitsu_source, fujitsu_ofort):
    assert fujitsu_source is not None

    result = subprocess.run(
        [str(fujitsu_ofort), "--check", str(fujitsu_source)],
        cwd=ROOT,
        text=True,
        capture_output=True,
        timeout=10,
    )

    assert result.returncode == 0, result.stdout + result.stderr
