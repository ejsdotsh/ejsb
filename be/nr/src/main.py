# nod.py

"""
Nornir + FastApi
"""

from fastapi import FastAPI
import uvicorn
from yaml import safe_load

from nornir import InitNornir
from nornir_napalm.plugins.tasks import napalm_get
from nornir_scrapli.tasks import send_command

# custom Nornir tasks
# from nod_collectors import collect_intf_state

NORNIR_CONFIG_FILE = "./nr_data/nr_config.yml"

# Initialize Nornir
nr = InitNornir(config_file=NORNIR_CONFIG_FILE)

# initialize FastAPI
nod = FastAPI()


@nod.get("/")
async def root():
    return {"message": "nothing to see here"}


@nod.get("/devices")
async def get_devices():
    """Returns list of devices loaded from Nornir hosts.yml."""
    with open("./inventories/nr/hosts.yml", encoding="utf-8") as hf:
        devices = safe_load(hf)
    return {"devices": devices}


@nod.get("/devices/{hostname}/napalm_get/{getter}")
async def get_config(hostname: str, getter: str):
    """
    Function used to interact with NAPALM-supported devices.

    https://napalm.readthedocs.io/en/latest/support/#general-support-matrix
    """
    rtr = nr.filter(name=f"{hostname}")
    return rtr.run(name=f"Get {hostname} {getter}", task=napalm_get, getters=[f"{getter}"])


if __name__ == "__main__":
    # uvicorn.run("main:nod", host="127.0.0.1", port=8080, reload=False, root_path="/")
    uvicorn.run("main:nod", host="0.0.0.0", port=8080, reload=False, root_path="/")