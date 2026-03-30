# Gibraltar Ignition Runtime + Ansible Polling

This project runs Ignition with Docker Compose and continuously deploys approved Ignition file content from Git using Ansible.

Current source of truth for Ignition content:

- `IGNITION_SOURCE_REPO_URL` (configured in `.env`)
- Default branch is controlled by `IGNITION_SOURCE_REPO_BRANCH`

## Architecture

### Docker Compose services

- `ignition`: Ignition Gateway container
- `postgres`: PostgreSQL backing database
- `portainer`: optional container management UI
- `dozzle`: optional log viewer
- `ansible-runner`: poller that executes `ansible-pull` on an interval

### Data flow

1. `ansible-runner` wakes up every `CD_POLL_INTERVAL` seconds.
2. It runs `ansible-pull` against `IGNITION_SOURCE_REPO_URL` and `IGNITION_SOURCE_REPO_BRANCH`.
3. `ansible-pull` checks out the repo into `/opt/gibraltar-cd/repo`.
4. It executes `ansible/playbooks/deploy-ignition.yml` using the local inventory.
5. The playbook stages content to `/opt/ignition-release/ignition-src/`.
6. The playbook backs up tracked folders from the Ignition volume into `/opt/ignition-backups/`.
7. The playbook synchronizes tracked folders into Docker volume path `/var/lib/docker/volumes/<volume>/_data`.

No container stop/start is performed during deploy.

## Repository Layout

- `docker-compose.yml`: service orchestration including `ansible-runner`
- `ansible/inventories/hosts.yml`: single local inventory used by all playbooks
- `ansible/playbooks/deploy-ignition.yml`: poll-driven deployment logic
- `ansible/playbooks/backup-ignition-volume.yml`: manual backup
- `ansible/playbooks/restore-ignition-volume.yml`: manual restore
- `ansible/ansible-runner-entrypoint.sh`: poll loop + `ansible-pull` command

## Inventory Model

This project uses one inventory file: `ansible/inventories/hosts.yml`.

It is local-only (`ansible_connection: local`) and provides:

- `ignition_volume_name` (for example `gibraltar_ignition_data_gibraltar`)
- `ignition_release_path` (`/opt/ignition-release`)
- `ignition_backup_path` (`/opt/ignition-backups`)

The deploy playbook derives the writable volume filesystem path as:

- `/var/lib/docker/volumes/{{ ignition_volume_name }}/_data`

Note: this assumes default Docker data-root. If your Docker data-root is customized, update this path logic accordingly.

## Tracked Ignition Folders

Based on current 8.3 alignment, deployment/backup/restore tracks:

- `projects/`
- `config/resources/`

These are controlled in each playbook via the `ignition_folders` variable.

## Configuration (.env)

Required variables:

- `CD_POLL_INTERVAL` (seconds)
- `IGNITION_SOURCE_REPO_URL`
- `IGNITION_SOURCE_REPO_BRANCH`
- `IGNITION_SOURCE_SUBPATH` (empty if content is at repo root)

Example:

```dotenv
CD_POLL_INTERVAL=300
IGNITION_SOURCE_REPO_URL=https://github.com/Bright-IA-Intelligent-Automation/gibraltar-ignition-src.git
IGNITION_SOURCE_REPO_BRANCH=master
IGNITION_SOURCE_SUBPATH=
```

## Operations

### Start or refresh stack

```bash
docker compose up -d --build
```

### View polling logs

```bash
docker logs -f ansible_runner_gibraltar
```

### Manual one-off deploy

```bash
cd ansible
ansible-playbook -i inventories/hosts.yml playbooks/deploy-ignition.yml -e target_hosts=localhost
```

### Manual backup

```bash
cd ansible
ansible-playbook -i inventories/hosts.yml playbooks/backup-ignition-volume.yml -e target_hosts=localhost
```

### Manual restore

```bash
cd ansible
ansible-playbook -i inventories/hosts.yml playbooks/restore-ignition-volume.yml -e target_hosts=localhost
```

## Playbook Execution Sequence

`ansible-runner-entrypoint.sh` continuously executes:

1. `ansible-pull` checkout/update
2. `deploy-ignition.yml` tasks in order:
	- ensure directories
	- stage source
	- ensure tracked directories
	- backup tracked volume folders
	- synchronize tracked folders into the Ignition volume

If deployment fails, the loop logs the error and retries at the next polling interval.
