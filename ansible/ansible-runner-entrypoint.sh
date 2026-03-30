#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${IGNITION_SOURCE_REPO_URL:?IGNITION_SOURCE_REPO_URL must be set in .env}"
BRANCH="${IGNITION_SOURCE_REPO_BRANCH:?IGNITION_SOURCE_REPO_BRANCH must be set in .env}"
POLL_INTERVAL="${CD_POLL_INTERVAL:?CD_POLL_INTERVAL must be set in .env}"
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
      -i "${CHECKOUT_DIR}/ansible/inventories/hosts.yml" \
      -e target_hosts=localhost \
      ansible/playbooks/deploy-ignition.yml \
    && echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] ansible-pull succeeded" \
    || echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] ansible-pull FAILED — will retry in ${POLL_INTERVAL}s"

    sleep "${POLL_INTERVAL}"
done
