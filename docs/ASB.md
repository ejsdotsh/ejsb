# Ansible System Builder

## machines

builds and configures each `machine`

- nas
- www
- switch

## my roles

## playbook overview

- `provision.yml` imports `configure.yml` to provision and configure the given hosts

```txt

```

- `configure.yml` imports the machine(s) to be configured and configures them

```txt

```

- `machines/` is the top-level directory for the semi-defined machine-level roles (i.e. db, www, nas, dns, etc)

## inventories and sources-of-truth

the inventory is the `source-of-truth` and ansible-like until i define yet another infrastructure data model (YAIDM?) and write the plugins to use it.

## references and inspiration

- [Ansible-NAS](https://ansible-nas.io/)
- [Ansible for DevOps](https://github.com/geerlingguy/ansible-for-devops)
