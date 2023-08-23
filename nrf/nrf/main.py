# nrf.py

"""
Nornir + FastApi
"""

# typing imports
from typing import Any, Literal
from nornir.core import Nornir
from nornir.core.task import AggregatedResult, Result

# function imports
from nornir import InitNornir
from nornir_napalm.plugins.tasks import napalm_get
from nornir_scrapli.tasks import send_command
from yaml import safe_load

# fastapi
from fastapi import FastAPI
import uvicorn

# custom Nornir tasks
# from nrf_collectors import collect_intf_state


NORNIR_CONFIG_FILE: Literal['./config/nr_config.yml'] = "./config/nr_config.yml"

# Initialize Nornir
nr: Nornir = InitNornir(config_file=NORNIR_CONFIG_FILE)

# initialize FastAPI
nrf: FastAPI = FastAPI()


@nrf.get("/")
async def root() -> dict[str, str]:
    return {"message": "nothing to see here"}


@nrf.get("/devices")
async def get_devices() -> dict[str, Any]:
    """Returns list of devices loaded from Nornir hosts.yml."""
    with open("./config/hosts.yml", encoding="utf-8") as hf:
        devices = safe_load(hf)
    return {"devices": devices}


@nrf.get("/devices/{hostname}/napalm_get/{getter}", response_model=None)
async def get_config(hostname: str, getter: str) -> dict[str, Result]:
    """
    Function used to interact with NAPALM-supported devices.
    https://napalm.readthedocs.io/en/latest/support/#general-support-matrix
    """
    rtr: Nornir = nr.filter(name=f"{hostname}")
    result = rtr.run(
        name=f"Get {hostname} {getter}",
        task=napalm_get,
        getters=[f"{getter}"],
    )[hostname]
    return {f"{hostname}": result[0]}


def read_intf_state() -> dict[str, Any]:
    """Returns textfsm-parsed output from scrapli `show interfaces`."""
    intf: dict[str, Any] = dict()
    rtr: Nornir = nr.filter(platform="junos")
    result: AggregatedResult = rtr.run(
        name="netstate/interfaces",
        task=send_command,
        command="show interfaces",
    )
    for h, r in result.items():
        pi = r.scrapli_response.textfsm_parse_output()
        intf[h] = pi

    return intf


if __name__ == "__main__":
    uvicorn.run("main:nrf", host="127.0.0.1", port=8080, reload=False, root_path="/")
    # uvicorn.run("main:nrf", host="0.0.0.0", port=8080, reload=False, root_path="/")
