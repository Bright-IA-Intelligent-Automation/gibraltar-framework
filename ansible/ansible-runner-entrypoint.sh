#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${GIT_REPO_URL:?GIT_REPO_URL must be set (e.g. https://github.com/<org>/<repo>.git)}"
BRANCH="${GIT_BRANCH:-master}"
POLL_INTERVAL="${CD_POLL_INTERVAL:-300}"
CHECKOUT_DIR="/opt/gibraltar-cd/repo"

echo "=== Gibraltar ansible-pull CD runner ==="
echo "  Repo:     ${REPO_URL}"
echo "  Branch:   ${BRANCH}"
echo "  Interval: ${POLL_INTERVAL}s"
echo "========================================"

while true; do
    echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] Running ansible-pull..."

    ansible-pull \
      --accept-host-key \
      --clean \
      -U "${REPO_URL}" \
      -C "${BRANCH}" \
      -d "${CHECKOUT_DIR}" \
      -i "${CHECKOUT_DIR}/ansible/inventories/local/hosts.yml" \
      -e target_hosts=localhost \
      ansible/playbooks/deploy-ignition.yml \
    && echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] ansible-pull succeeded" \
    || echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] ansible-pull FAILED — will retry in ${POLL_INTERVAL}s"

    sleep "${POLL_INTERVAL}"
done
