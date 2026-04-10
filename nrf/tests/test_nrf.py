# tests/test_nrf.py

from nrf import __version__

def test_version() -> None:
    assert __version__ == "0.0.1"
