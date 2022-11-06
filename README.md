# WIP - NOD

what is `NOD`:

- Network Orchestration Director
- Network Operations Dashboard
- Network Operations Director
- ???

the definition is unclear, as this is currently an API for scraping the output of show commands from network devices
in a nornir/gornir inventory, and returning JSON

some potential use-cases:

- network state report
  - interface utilization
  - compliance (version, config, etc)
    - config changes
- locate a host by mac-address or IP, return (optionally change) the configuration
- back-up configs to version control

## introduction

this howto is as much about learning as it is about teaching.

the following is adapted from Dave Barroso's, [building scalable tooling](https://www.dravetech.com/presos/building_scalable_tooling/slides.html) presentation,
which if you haven't read, i highly recommend. (*emphasis mine*):

> **Why do we want automation?**
>
> - **Reliability**
>   - Does our software do what we claim it does?
>   - Can we change it without breaking anything?
>   - Test the interactions with the system from a user perspective *first*, then add tests to simulate (fixed) bugs
> - **Consistency**
>   - Avoid cognitive overhead which can lead to bugs, wasted time, and bikeshedding
>   - Adopt frameworks and best practices
>     - ***Choose a framework and stick by it unless strictly necessary***
>     - If you need external services, standardize and adopt them across the board (i.e., databases, message buses, etc)
>     - Adopt a coding style (or an opinionated linter) to minimize arguments about style (i.e., black)
>   - The goal is to be able to collaborate on multiple projects without having to pay a very expensive context switch
>     cost or waste time arguing about tabs vs spaces or MySQL vs postgres
> - **Maintainability**
>   - Readability
>     - Code is read more often than it is written so optimize for reading
>   - Abstractions
>     - Break down your code into different layers of abstraction
>     - Each abstraction should be concerned about solving the problem presented in its layer
>     - Each abstraction should provide a stable contract so other abstractions can consume it
>     - Abstractions are good for the separation of concerns
>       - Give the request of deploying a service, can my software identify which parts need to be configured and which
>         parameters need to be set?
>       - Given the right input, is my service generating the correct configuration?
>       - Given some configuration, is my library able to deploy it correctly to the device?
>   - Developer's tooling
>     - A developer should have tooling to:
>       - Help write code; autocompletion, inline documentation, refactoring, etc...
>       - Inspect and explore what the program is doing during its execution
>       - Observe how the system behaves in production
>
> **Speed is not a goal but a consequence**

## components

### frontend

tbd

- jupyter notebook(s) for data analysis, reporting, and display

### backend

- nornir + fastapi
- gornir + net/http

- builds [FastAPI](https://fastapi.tiangolo.com/)+[Nornir](https://nornir.readthedocs.io/en/latest/) backend
- builds [net/http](https://pkg.go.dev/net/http)+[Gornir](https://github.com/nornir-automation/gornir/) backend

[gornir](https://github.com/nornir-automation/gornir), augmented by [scrapligo](https://github.com/scrapli/scrapligo)

> Gornir is a pluggable framework with inventory management to help operate collections of devices. It's similar to
> nornir but in golang.
>
> The goal is to be able to operate on many devices with little effort.

`scrapligo` was chosen for its support of `textfsm` templates:

> scrapligo -- scrap(e c)li (but in go!) -- is a Go library focused on connecting to devices, specifically network
> devices (routers/switches/firewalls/etc.) via SSH and NETCONF.

[nornir], augmented by [nornir_scrapli] and [nornir_napalm]

### data persistence

***TODO***

- git
- mongodb
- postgresql

## build stuff

### build instructions

this project uses `make` and `containers`

`make nod`

- builds everything

`make nodpy`

- builds FastAPI+Nornir backend

`make nodgo`

- builds net/http+Gornir backend

TODO `make nodfe`

- builds the nod frontend

the first components to build are the APIs, and their associated collectors.

### building the API

the API will collect *state* information from the network, transform it into JSON, and serve it over (RESTful?) HTTPS
endpoints. to solve the initial use cases, the following endpoint are defined:

- `/netstate`
- `/netstate/interfaces/`
- `/compliance`
- `/findme`
- `netbackup`

#### Nornir and FastAPI

  ```py3
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
  ```

## references/inspiration

- [JulioPDX Nornir+Fastapi](https://juliopdx.com/2021/09/01/integrating-nornir-with-fastapi/)
- [Sebastian Ramirez](https://realpython.com/fastapi-python-web-apis/)
- [network MOPs as automated workflows](https://www.ansible.com/blog/network-mops-as-automated-workflows)
- [how to build a network automation stack with nornir, napalm, and netbox](https://www.packetcoders.io/how-to-build-a-network-automation-stack-with-nornir-napalm-and-netbox/)
