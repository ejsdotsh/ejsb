# Ansible System Builder

what began as a personal fork of Ansible-NAS to replace FreeNAS, is being rewritten as more general tooling to better integrate with Terraform and Packer

## machines

a `machine` is a playbook to build and configure coupled functions and services on groups of hosts in an idempotent manner. where possible, `tasks` have been abstracted into `roles` for modularity and easier reuse.

- nas
  - a ZFS-based file and application server
- www
  - a webserver using nginx + let's encrypt to serve HTTPS
- switch
  - initially for juniper ex devices
  - additional vendors and platforms are tbd

## roles

- global_handlers
  - keep all handlers in one place
- omada
  - pulls/runs the container for my wifi controller
- docker
  - installs/configures Docker
- ufw
  - i'm currently using UFW to manage nftables; it doesn't play well with containers, however
  - TODO rename to `firewall`, switch to `firewall-cmd`

## playbook overview

- `provision.yml` imports `configure.yml` to provision and configure the given hosts

- `configure.yml` imports the machine(s) to be configured and configures them

### provisioners

- linode
  - get account information
  - create/delete an instance

## inventories and sources-of-truth

the inventory is the `source-of-truth` and ansible-like until i define yet another infrastructure data model (YAIDM?) and write the plugins to use it.

## references and inspiration

- [Ansible-NAS](https://ansible-nas.io/)
- [Ansible for DevOps](https://github.com/geerlingguy/ansible-for-devops)
