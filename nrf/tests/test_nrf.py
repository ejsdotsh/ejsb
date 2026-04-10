# SPDX-FileCopyrightText: 2022-Present j. e.j. sahala <git@ejs.sh>
#
# SPDX-License-Identifier: MPL-2.0

# tests/test_nrf.py

from nrf import __version__

def test_version() -> None:
    assert __version__ == "0.0.1"
