#!/bin/bash
set -euo pipefail

# This script is "apt-key free" and works on Debian trixie+
# It installs keys into /etc/apt/keyrings/*.gpg and ensures your repo .list files
# use signed-by=... so apt can verify them without apt-key.

: "${FILE_FOLDER:?FILE_FOLDER must be set to the folder containing your *.list files}"

export DEBIAN_FRONTEND=noninteractive

log() { echo "[$(date -Is)] $*"; }

install_packages() {
  log "Installing base packages..."
  apt-get update -q
  apt-get install -y -q --no-install-recommends \
    wget curl gnupg ca-certificates
}

ensure_keyrings_dir() {
  mkdir -p /etc/apt/keyrings
  chmod 0755 /etc/apt/keyrings
}

# Fetch a public key from Ubuntu keyserver and install it as a keyring file
install_key_from_keyserver() {
  local keyid="$1"   # hex key id, no 0x
  local out="$2"     # /etc/apt/keyrings/name.gpg
  log "Installing key from keyserver: ${keyid} -> ${out}"
  curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x${keyid}" \
    | gpg --dearmor -o "${out}"
  chmod 0644 "${out}"
}

# Download an ASCII armored key (or binary) and install it as a keyring file
install_key_from_url() {
  local url="$1"
  local out="$2"
  log "Installing key from URL: ${url} -> ${out}"
  curl -fsSL "${url}" | gpg --dearmor -o "${out}"
  chmod 0644 "${out}"
}

# Download a binary .gpg key directly (no dearmor needed)
install_key_binary_url() {
  local url="$1"
  local out="$2"
  log "Installing binary key: ${url} -> ${out}"
  wget -q -O "${out}" "${url}"
  chmod 0644 "${out}"
}

install_repo_lists() {
  log "Installing repository list files from: ${FILE_FOLDER}"

  install -m 0644 -v "${FILE_FOLDER}/nodesource.list"        "/etc/apt/sources.list.d/" || true
  install -m 0644 -v "${FILE_FOLDER}/mopidy.list"            "/etc/apt/sources.list.d/" || true
  install -m 0644 -v "${FILE_FOLDER}/raspotify.list"         "/etc/apt/sources.list.d/" || true
  install -m 0644 -v "${FILE_FOLDER}/debian-backports.list"  "/etc/apt/sources.list.d/" || true
  install -m 0644 -v "${FILE_FOLDER}/opencpn.list"           "/etc/apt/sources.list.d/" || true
  install -m 0644 -v "${FILE_FOLDER}/xygrib.list"            "/etc/apt/sources.list.d/" || true
  install -m 0644 -v "${FILE_FOLDER}/bbn-navtex.list"        "/etc/apt/sources.list.d/" || true
  install -m 0644 -v "${FILE_FOLDER}/bbn-noaa-apt.list"      "/etc/apt/sources.list.d/" || true
  install -m 0644 -v "${FILE_FOLDER}/stellarium.list"        "/etc/apt/sources.list.d/" || true

  # Prefer opencpn PPA to free-x (mainly for opencpn package)
  install -m 0644 -v "${FILE_FOLDER}/50-lysmarine.pref" "/etc/apt/preferences.d/" || true
}

install_keys() {
  ensure_keyrings_dir

  # --- Keys previously fetched via: apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ...
  # bbn PPAs on launchpad
  install_key_from_keyserver 24A4598E769C8C51 /etc/apt/keyrings/bbn-launchpad.gpg
  # Opencpn (two keys in your script)
  install_key_from_keyserver 67E4A52AC865EB40 /etc/apt/keyrings/opencpn-67e4a52a.gpg
  install_key_from_keyserver 6AF0E1940624A220 /etc/apt/keyrings/opencpn-6af0e194.gpg
  # lysmarine
  install_key_from_keyserver 868273EDCE9979E7 /etc/apt/keyrings/lysmarine.gpg
  # Chirp
  install_key_from_keyserver 6EA1BC913BC5163F /etc/apt/keyrings/chirp.gpg
  # Stellarium
  install_key_from_keyserver 1932F485C68D72A5 /etc/apt/keyrings/stellarium.gpg

  # --- NodeSource (you already used keyrings; keep it)
  install_key_from_url \
    "https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key" \
    "/etc/apt/keyrings/nodesource.gpg"

  # --- Cloudsmith + others that used: curl ... | apt-key add -
  install_key_from_url \
    "https://dl.cloudsmith.io/public/bbn-projects/bbn-autoadb/gpg.A63E85DF4575A096.key" \
    "/etc/apt/keyrings/bbn-autoadb.gpg"

  install_key_from_url \
    "https://dl.cloudsmith.io/public/bbn-projects/bbn-gpsd/gpg.B3336FAFD344E1C5.key" \
    "/etc/apt/keyrings/bbn-gpsd.gpg"

  install_key_from_url \
    "https://dl.cloudsmith.io/public/bbn-projects/bbn-navtex/gpg.DCC56162C6CE6F68.key" \
    "/etc/apt/keyrings/bbn-navtex.gpg"

  install_key_from_url \
    "https://raw.githubusercontent.com/bareboat-necessities/lysmarine_gen/master/public-keys/cloudsmith-bbn-noaa-apt/gpg.DB5121F72251E833.key" \
    "/etc/apt/keyrings/bbn-noaa-apt.gpg"

  install_key_from_url \
    "https://www.free-x.de/debian/oss.boating.gpg.key" \
    "/etc/apt/keyrings/free-x-oss-boating.gpg"

  # Mopidy provides a binary key file; download as-is
  install_key_binary_url \
    "https://apt.mopidy.com/mopidy.gpg" \
    "/etc/apt/keyrings/mopidy-archive-keyring.gpg"
}

# Add signed-by to matching "deb ..." lines in a .list file (idempotent)
# Matches only lines that (a) start with deb, (b) contain repo_match, (c) don't already have [..] options.
add_signed_by_to_list() {
  local listfile="$1"
  local repo_match="$2"
  local keyring_path="$3"

  [ -f "${listfile}" ] || return 0

  # Only patch if repo_match exists in the file.
  if ! grep -qE "${repo_match}" "${listfile}"; then
    return 0
  fi

  log "Patching ${listfile} with signed-by=${keyring_path} for match: ${repo_match}"

  # Case 1: line is "deb http..." (no options block) -> insert [signed-by=...]
  # Case 2: line is "deb [arch=...] http..." (has options) -> append signed-by if missing
  #
  # We patch per-line, only when repo_match is on that line.

  # 1) Insert options block if absent and line matches repo
  perl -0777 -i -pe '
    my ($re, $key) = @ARGV;
    s{^(deb)\s+(?!\[[^\]]*\])(\S+.*'"$repo_match"'.*)$}
     {$1 [signed-by='"$keyring_path"'] $2}gmx;
  ' "${repo_match}" "${keyring_path}" "${listfile}"

  # 2) If options exist but signed-by missing, append it
  perl -0777 -i -pe '
    my ($re, $key) = @ARGV;
    s{^(deb)\s+\[([^\]]*?)\]\s+(\S+.*'"$repo_match"'.*)$}
     {
       my $opts = $2;
       if ($opts !~ /(?:^|\s)signed-by=/) { $opts .= " signed-by='"$keyring_path"'"; }
       "$1 [$opts] $3"
     }gmx;
  ' "${repo_match}" "${keyring_path}" "${listfile}"
}

patch_sources_signed_by() {
  log "Ensuring sources use signed-by=... keyrings"

  # Patch every installed list file based on URL patterns commonly present in the line.
  # Adjust/extend patterns if your .list content differs.
  local d="/etc/apt/sources.list.d"

  # NodeSource
  add_signed_by_to_list "${d}/nodesource.list"        'deb\.nodesource\.com'                '/etc/apt/keyrings/nodesource.gpg'

  # Mopidy
  add_signed_by_to_list "${d}/mopidy.list"            'apt\.mopidy\.com'                    '/etc/apt/keyrings/mopidy-archive-keyring.gpg'

  # free-x (xygrib / avnav etc.)
  add_signed_by_to_list "${d}/xygrib.list"            'free-x\.de'                          '/etc/apt/keyrings/free-x-oss-boating.gpg'

  # Cloudsmith repos (these patterns should match the repo URLs in your list files)
  add_signed_by_to_list "${d}/bbn-navtex.list"        'dl\.cloudsmith\.io/.*/bbn-navtex'    '/etc/apt/keyrings/bbn-navtex.gpg'
  add_signed_by_to_list "${d}/bbn-noaa-apt.list"      'dl\.cloudsmith\.io/.*/bbn-noaa-apt'  '/etc/apt/keyrings/bbn-noaa-apt.gpg'
  # If you also have list files for these repos, patch them too
  add_signed_by_to_list "${d}/bbn-autoadb.list"       'dl\.cloudsmith\.io/.*/bbn-autoadb'   '/etc/apt/keyrings/bbn-autoadb.gpg'
  add_signed_by_to_list "${d}/bbn-gpsd.list"          'dl\.cloudsmith\.io/.*/bbn-gpsd'      '/etc/apt/keyrings/bbn-gpsd.gpg'

  # Launchpad PPAs / Opencpn / Stellarium / Chirp etc.
  # If your .list uses ppa.launchpad.net URLs, this will attach the appropriate key.
  # NOTE: Opencpn has two keys in your original; pick one consistently for signed-by.
  add_signed_by_to_list "${d}/opencpn.list"           'ppa\.launchpad\.net'                 '/etc/apt/keyrings/opencpn-67e4a52a.gpg'
  add_signed_by_to_list "${d}/stellarium.list"        'ppa\.launchpad\.net'                 '/etc/apt/keyrings/stellarium.gpg'
  add_signed_by_to_list "${d}/chirp.list"             'ppa\.launchpad\.net'                 '/etc/apt/keyrings/chirp.gpg'

  # If your bbn PPAs are on launchpad, they likely use ppa.launchpad.net too:
  add_signed_by_to_list "${d}/bbn-ppa.list"           'ppa\.launchpad\.net'                 '/etc/apt/keyrings/bbn-launchpad.gpg'
}

final_apt() {
  log "Running apt update/upgrade/autoremove..."
  apt-get update -q
  apt-get upgrade -y -q
  apt-get autoremove -y --purge

  # In containers, systemd may not be running; guard this to avoid failing CI.
  if command -v systemctl >/dev/null && [ -d /run/systemd/system ]; then
    log "Running systemctl preset-all..."
    systemctl preset-all
  else
    log "Skipping systemctl preset-all (systemd not active)."
  fi
}

main() {
  install_packages
  install_repo_lists
  install_keys
  patch_sources_signed_by
  final_apt
  log "Done."
}

main "$@"
