# NRF

(pronounced like `nerf`)

an API and command-line tool written in Python using [Nornir](https://nornir.tech/nornir/) and [FastAPI](https://fastapi.tiangolo.com/) that (currently) scrapes the output of show commands from network devices in a [Nornir inventory](https://nornir.readthedocs.io/en/latest/tutorial/inventory.html), using [nornir_napalm's](https://github.com/nornir-automation/nornir_napalm) `get_*` methods, and returns the results as JSON.

> Nornir is a pure Python automation framework intented to be used directly from Python. While most automation frameworks use their own Domain Specific Language (DSL) which you use to describe what you want to have done, Nornir lets you control everything from Python.

the initial API endpoints are:

- `/devices`
  - returns a JSON list of all devices in the inventory
- `/devices/{hostname}/getter/{getter}`
  - returns the results of a supported `NAPALM` *getter*
    - `facts`
    - `config`
    - `interfaces`
    - please see [getters support matrix](https://napalm.readthedocs.io/en/latest/support/index.html#getters-support-matrix) for the complete list

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

### potential future use-cases and features

- writing something similar with Gornir + Net/HTTP (and calling it `grn`)
- a command line
  - with the same *getters*

  `$ ./nrf --hostname {{hostname}} --getter {{ (facts|config|interfaces) }}`

- each API will asynchronously collect, and optionally store, *state* information from supported systems, transform it into JSON, and serve it to (RESTful?) HTTPS endpoints or CLI commands.
- dashboards and reporting
  - status
  - utilization
  - standards compliance
  - locate a host by mac-address or IP, return (optionally change) the configuration
- configuration backup and version control
- configuration changes and verification
- jupyter notebook(s) for interactive data analysis, dashboards, training and documentation, ops playbooks, and reporting

## TODO - data persistence

- git
- mongodb
- postgresql
