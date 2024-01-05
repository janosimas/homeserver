# homeserver

This repository is a collection of scripts and configuration files to help setting a homeserver.

**IMPORTANT**: These are experiments and should not be considered production ready or safe

# Ansible

When using ansible, set the variables in `ansible/vars/main_vars.yml`

## Containers

The services can be started using the `start_service.sh` script.

This script assumes that the `ansible/setup_playbook.yml` was executed.
