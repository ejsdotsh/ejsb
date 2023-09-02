# homelab

the collection of learning, experimentation, and opinionated tooling that i write to manage my personal infrastructure, which consists of:

- my websites running on 

***...caution, this is a work in progress, breaking changes ahead...***

## asb

- [asb](asb) (aka Ansible Systems Builder)
  - what began as a personal fork of Ansible-NAS to replace FreeNAS, is being rewritten as more general tooling to better integrate with Terraform and Packer

## nrf

playing with Nornir + FastAPI to create an asynchrous network API.

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
