# Ignition Docker + Ansible (Minimal)

This repository layout keeps Ignition source-controlled files in `ignition-src/` and deploys approved changes into a Docker named volume with Ansible.

## Layout

- `docker-compose.yml` - Ignition, PostgreSQL, Portainer, and Dozzle
- `ignition-src/` - version-controlled Ignition content
- `ansible/` - backup, deploy, and restore playbooks
- `scripts/` - local helper scripts

## Workflow

1. Export local Ignition named volume into `ignition-src/`.
2. Commit and push changes.
3. Open and merge a pull request.
4. Run Ansible deploy playbook against the customer server.
5. Ansible backs up the live named volume, syncs approved files, and restarts Ignition.

## Tracked Ignition folders

Track only these folders under `ignition-src/`:

- `projects/`
- `gateways/`
- `user-lib/`
- `modules/`

## Notes

- Production uses a Docker named volume for Ignition data.
- Ansible copies files from `ignition-src/` into the named volume.
- Update placeholder values in [ansible/inventories/prod/hosts.yml](ansible/inventories/prod/hosts.yml) before deployment.
