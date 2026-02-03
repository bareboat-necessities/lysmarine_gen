#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
export TERM="${TERM:-dumb}"

export BBN_KIND="LITE"
export LMARCH="arm64"
export BBN_OS_CODENAME="trixie"

log() {
  echo "[$(date -Is)] $*"
}

require_root() {
  if [ "${EUID:-$(id -u)}" -ne 0 ]; then
    log "ERROR: install scripts must run as root."
    exit 1
  fi
}

require_arch() {
  local arch
  arch="$(dpkg --print-architecture)"
  if [ "$arch" != "$LMARCH" ]; then
    log "ERROR: unsupported architecture '$arch' (expected $LMARCH)."
    exit 1
  fi
}

require_trixie() {
  local codename=""
  if [ -r /etc/os-release ]; then
    codename="$(. /etc/os-release && echo "${VERSION_CODENAME:-}")"
  fi
  if [ -z "$codename" ] && command -v lsb_release >/dev/null 2>&1; then
    codename="$(lsb_release -cs)"
  fi
  if [ "$codename" != "$BBN_OS_CODENAME" ]; then
    log "ERROR: unsupported OS codename '${codename:-unknown}' (expected $BBN_OS_CODENAME)."
    exit 1
  fi
}

skip_if_lite() {
  local reason="${1:-optional component}"
  if [ "$BBN_KIND" = "LITE" ]; then
    log "Skipping $reason for LITE build."
    exit 0
  fi
}
