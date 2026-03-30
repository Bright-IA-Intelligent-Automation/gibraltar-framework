#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${IGNITION_SOURCE_REPO_URL:?IGNITION_SOURCE_REPO_URL must be set in .env}"
BRANCH="${IGNITION_SOURCE_REPO_BRANCH:?IGNITION_SOURCE_REPO_BRANCH must be set in .env}"
POLL_INTERVAL="${CD_POLL_INTERVAL:?CD_POLL_INTERVAL must be set in .env}"
CHECKOUT_DIR="/opt/gibraltar-cd/repo"
FRAMEWORK_ROOT="/opt/gibraltar-framework"

echo "=== Gibraltar deploy runner ==="
echo "  Repo:     ${REPO_URL}"
echo "  Branch:   ${BRANCH}"
echo "  Interval: ${POLL_INTERVAL}s"
echo "========================================"

while true; do
    echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] Syncing source repository..."

    if [[ -d "${CHECKOUT_DIR}/.git" ]]; then
      git -C "${CHECKOUT_DIR}" remote set-url origin "${REPO_URL}"
      git -C "${CHECKOUT_DIR}" fetch --depth 1 origin "${BRANCH}"
      git -C "${CHECKOUT_DIR}" checkout -B "${BRANCH}" "origin/${BRANCH}"
      git -C "${CHECKOUT_DIR}" reset --hard "origin/${BRANCH}"
      git -C "${CHECKOUT_DIR}" clean -fdx
    else
      rm -rf "${CHECKOUT_DIR}"
      git clone --depth 1 --branch "${BRANCH}" "${REPO_URL}" "${CHECKOUT_DIR}"
    fi

    echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] Running deploy playbook..."

    IGNITION_SOURCE_CHECKOUT_DIR="${CHECKOUT_DIR}" \
    ansible-playbook \
      -i "${FRAMEWORK_ROOT}/inventories/hosts.yml" \
      "${FRAMEWORK_ROOT}/playbooks/deploy-ignition.yml" \
      -e target_hosts=localhost \
    && echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] deploy succeeded" \
    || echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] deploy FAILED — will retry in ${POLL_INTERVAL}s"

    sleep "${POLL_INTERVAL}"
done
