# NDOTS -- Network Development Operations Tooling Setup

## NRF

(pronounced like `nerf`)

an API written in Python using [Nornir](https://nornir.tech/nornir/) and [FastAPI](https://fastapi.tiangolo.com/) that (currently) scrapes the output of show commands from network devices in a [Nornir inventory](https://nornir.readthedocs.io/en/latest/tutorial/inventory.html), using [nornir_napalm's](https://github.com/nornir-automation/nornir_napalm) `get_*` methods, and returns the results as JSON.

- potential future use-cases and features:
  - dashboards and reporting:
    - status
    - utilization
    - standards compliance
    - locate a host by mac-address or IP, return (optionally change) the configuration
  - configuration backup and version control
  - configuration changes and verification
  - jupyter notebook(s) for interactive data analysis, dashboards, training and documentation, ops playbooks, and reporting

> Nornir is a pure Python automation framework intented to be used directly from Python. While most automation frameworks use their own Domain Specific Language (DSL) which you use to describe what you want to have done, Nornir lets you control everything from Python.

## GRN

(pronounced like `grin`)

an API written in Go using [Gornir](https://nornir.tech/gornir/), augmented by [scrapligo](https://github.com/scrapli/scrapligo), and [Net/HTTP](https://pkg.go.dev/net/http) to scrape the output of show commands and return result as JSON. it's like `nrf`, but in Go.

> Gornir is a pluggable framework with inventory management to help operate collections of devices. It's similar to nornir but in golang.

 `scrapligo` was chosen for its support of `textfsm` templates.

> scrapligo -- scrap(e c)li (but in go!) -- is a Go library focused on connecting to devices, specifically network
> devices (routers/switches/firewalls/etc.) via SSH and NETCONF.

### data persistence

***TODO***

- git
- mongodb
- postgresql



### defining the API

the API will collect *state* information from the network, transform it into JSON, and serve it over (RESTful?) HTTPS endpoints. to solve the initial use cases, the following endpoint are defined:

- `/netstate`
- `/netstate/interfaces/`
- `/netbackup`

#### Nornir and FastAPI

  ```py3
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
