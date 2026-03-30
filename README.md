# Ignition Docker + Ansible

This repository contains Ansible deployment automation for Ignition. Ignition source content is now stored in `https://github.com/Bright-IA-Intelligent-Automation/gibraltar-ignition-src` and is pulled during deployment.

## Layout

- `docker-compose.yml` - Ignition, PostgreSQL, Portainer, and Dozzle
- `ansible/` - inventory, playbooks, and CI/CD bootstrap assets
- `scripts/` - local helper scripts

## Tracked Ignition folders

Track only these folders in the source repository:

- `projects/`
- `config/resources/`

## Manual deploy (push model)

Use this when your Ansible control machine can SSH to the Ignition server.

1. Export local Ignition named volume into the `gibraltar-ignition-src` repository.
2. Commit and push changes.
3. Open and merge a pull request.
4. Run deploy:

```bash
cd ansible
ansible-playbook playbooks/deploy-ignition.yml
```

## CI/CD behind VPN (recommended pull model)

If GitHub-hosted runners cannot reach your server over SSH/VPN, use a pull model:

1. GitHub Actions validates every PR and `master` merge.
2. The server runs `ansible-pull` on a timer.
3. After merge to `master`, server pulls latest repo and applies `deploy-ignition.yml` locally.

This works with outbound-only internet from the server and does not require inbound access from GitHub Actions.

### One-time server setup

Server prerequisites:

- Docker and Docker CLI installed.
- `ansible-core` installed on the server (`ansible-pull` command available).
- Git installed on the server.

Run the bootstrap playbook against your server:

```bash
cd ansible
ansible-playbook playbooks/bootstrap-ansible-pull-cd.yml \
	-e git_repo_url=https://github.com/<org>/<repo>.git \
	-e git_branch=master
```

Optional settings:

- `cd_timer_on_calendar` (default: `*:0/5`) controls polling frequency.
- `ansible_pull_inventory` (default: `ansible/inventories/local/hosts.yml`).
- `ansible_pull_playbook` (default: `ansible/playbooks/deploy-ignition.yml`).
- `IGNITION_SOURCE_REPO_URL` (default: `https://github.com/Bright-IA-Intelligent-Automation/gibraltar-ignition-src.git`).
- `IGNITION_SOURCE_REPO_BRANCH` (default: `master`).
- `IGNITION_SOURCE_SUBPATH` (default: empty; set if source folders live in a subdirectory of that repo).

### Private repository authentication (if needed)

Create `/etc/gibraltar-cd/env` on the server:

```bash
sudo install -m 0750 -d /etc/gibraltar-cd
sudo bash -lc 'cat > /etc/gibraltar-cd/env <<EOF
GIT_REPO_URL=https://<token>@github.com/<org>/<repo>.git
GIT_BRANCH=master
IGNITION_SOURCE_REPO_URL=https://<token>@github.com/Bright-IA-Intelligent-Automation/gibraltar-ignition-src.git
IGNITION_SOURCE_REPO_BRANCH=master
IGNITION_SOURCE_SUBPATH=
EOF'
sudo chmod 0640 /etc/gibraltar-cd/env
```

For better security, use a GitHub deploy key instead of embedding a token in URL.

### Local inventory for server-side pull

`ansible/inventories/local/hosts.yml` is configured for local execution on the Docker host and uses:

- container name: `ignition_gibraltar`
- volume name: `gibraltar_ignition_data_gibraltar`

Adjust these if your environment differs.

### Verify timer on server

```bash
systemctl status gibraltar-ansible-pull.timer
systemctl list-timers gibraltar-ansible-pull.timer
journalctl -u gibraltar-ansible-pull.service -n 100 --no-pager
```

## Notes

- Production uses a Docker named volume for Ignition data.
- Deploy playbook backs up tracked folders before applying approved files.
- Update placeholder values in `ansible/inventories/prod/hosts.yml` before using push-model deploy.
