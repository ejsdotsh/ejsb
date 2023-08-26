# network development operations tooling setup (ndots)

**`ndots`** is a grandiose name for the collection of learning, experimentation, and opinionated tooling that i've written to manage my personal infrastructure/aka my *homelab*.

this project is about learning and documenting what i've done to share knowledge.

***...caution, this is a work in progress, breaking changes ahead...***

## asb

- [asb](asb) (aka Ansible Systems Builder)
  - what began as a personal fork of Ansible-NAS to replace FreeNAS, is being rewritten as more general tooling to better integrate with Terraform and Packer

## nrf

playing with Nornir + FastAPI to create an asynchrous network API. the initial API endpoints are:

- `/devices`
  - returns a JSON list of all devices in the inventory
- `/devices/{hostname}/getter/{getter}`
  - returns the results of a supported `NAPALM` *getter*
    - `facts`
    - `config`
    - `interfaces`
    - please see [getters support matrix](https://napalm.readthedocs.io/en/latest/support/index.html#getters-support-matrix) for the complete list

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

## build instructions

...are being rewritten

## references/inspiration

- from Dave Barroso's most-excellent [Building Scalable Tooling](https://www.dravetech.com/presos/building_scalable_tooling/slides.html) presentation (*emphasis mine*):

    >
    > ### Why do we want automation?
    >
    > #### Reliability
    >
    > - Does our software do what we claim it does?
    > - Can we change it without breaking anything?
    > - Test the interactions with the system from a user perspective *first*, then add tests to simulate (fixed) bugs
    >
    > #### Consistency
    >
    > - Avoid cognitive overhead which can lead to bugs, wasted time, and bikeshedding
    > - Adopt frameworks and best practices
    >   - ***Choose a framework and stick by it unless strictly necessary***
    >   - If you need external services, standardize and adopt them across the board (i.e., databases, message buses, etc)
    >   - Adopt a coding style (or an opinionated linter) to minimize arguments about style (i.e., black)
    > - The goal is to be able to collaborate on multiple projects without having to pay a very expensive context switch cost or waste time arguing about tabs vs spaces or MySQL vs postgres
    >
    > #### Maintainability
    >
    > - Readability
    >   - Code is read more often than it is written so optimize for reading
    > - Abstractions
    >   - Break down your code into different layers of abstraction
    >   - Each abstraction should be concerned about solving the problem presented in its layer
    >   - Each abstraction should provide a stable contract so other abstractions can consume it
    >   - Abstractions are good for the separation of concerns
    >     - Given the request of deploying a service, can my software identify which parts need to be configured and which parameters need to be set?
    >     - Given the right input, is my service generating the correct configuration?
    >     - Given some configuration, is my library able to deploy it correctly to the device?
    > - Developer's tooling
    >   - A developer should have tooling to:
    >     - Help write code
    >       - autocompletion, inline documentation, refactoring, etc...
    >     - Inspect and explore what the program is doing during its execution
    >     - Observe how the system behaves in production
    >
    > ### Speed is not a goal but a consequence
    >

- [Ansible for DevOps](https://www.ansiblefordevops.com/)
- [DebOps](https://docs.debops.org/en/stable-3.0/)
- [JulioPDX Nornir+Fastapi](https://juliopdx.com/2021/09/01/integrating-nornir-with-fastapi/)
- [Sebastian Ramirez](https://realpython.com/fastapi-python-web-apis/)
- [network MOPs as automated workflows](https://www.ansible.com/blog/network-mops-as-automated-workflows)
- [how to build a network automation stack with nornir, napalm, and netbox](https://www.packetcoders.io/how-to-build-a-network-automation-stack-with-nornir-napalm-and-netbox/)
