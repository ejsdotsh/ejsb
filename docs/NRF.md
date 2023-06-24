# NRF

(pronounced like `nerf`)

an API and command-line tool written in Python using [Nornir](https://nornir.tech/nornir/) and [FastAPI](https://fastapi.tiangolo.com/) that (currently) scrapes the output of show commands from network devices in a [Nornir inventory](https://nornir.readthedocs.io/en/latest/tutorial/inventory.html), using [nornir_napalm's](https://github.com/nornir-automation/nornir_napalm) `get_*` methods, and returns the results as JSON.

> Nornir is a pure Python automation framework intented to be used directly from Python. While most automation frameworks use their own Domain Specific Language (DSL) which you use to describe what you want to have done, Nornir lets you control everything from Python.

## example code for supported API endpoints

  ```python
  @nrf.get("/devices")
  async def get_devices():
      """Returns list of devices loaded from Nornir hosts.yml."""
      with open("./inventories/nr/hosts.yml", encoding="utf-8") as hf:
          devices = safe_load(hf)
      return {"devices": devices}

  @nrf.get("/devices/{hostname}/napalm_get/{getter}")
  async def get_config(hostname: str, getter: str):
      """
      Function used to interact with NAPALM-supported devices.

      https://napalm.readthedocs.io/en/latest/support/#general-support-matrix
      """
      rtr = nr.filter(name=f"{hostname}")
      return rtr.run(name=f"Get {hostname} {getter}", task=napalm_get, getters=[f"{getter}"])
  ```

## TODO - data persistence

- git
- mongodb
- postgresql
