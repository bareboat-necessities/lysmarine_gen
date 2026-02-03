#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a
export TERM="${TERM:-dumb}"

is_tty() { [ -t 1 ]; }
has_systemd() { command -v systemctl >/dev/null 2>&1 && [ -d /run/systemd/system ]; }

# In CI containers, systemctl usually can't talk to PID 1; make it a no-op there.
systemctl_safe() {
  if has_systemd; then
    systemctl "$@"
  else
    echo "[skip] systemctl $* (systemd not active)"
    return 0
  fi
}

# Some tools (like plymouth-set-default-theme) may exist but still require systemd/update-initramfs;
# keep them from failing CI.
run_if_exists() {
  local cmd="$1"; shift
  if command -v "$cmd" >/dev/null 2>&1; then
    "$cmd" "$@"
  else
    echo "[skip] $cmd not found"
    return 0
  fi
}

apt-get update -q
apt-get install -y -q --no-install-recommends \
  plymouth plymouth-label libblockdev-mdraid3

## Override default tty1 behaviour to make it more discrete during boot
install -v -d "/etc/systemd/system/getty@tty1.service.d"
install -v -m0644 "$FILE_FOLDER/skip-prompt.conf" "/etc/systemd/system/getty@tty1.service.d/skip-prompt.conf"

# RaspOS
if [ -f /boot/config.txt ]; then
  if [ "${LMARCH:-}" = 'armhf' ]; then
    echo "arm_64bit=1" >> "$(realpath /boot/config.txt)"
  fi
  cat "$FILE_FOLDER/appendToConfig.txt" >> "$(realpath /boot/config.txt)"
  #sed -i 's/-kms-v3d$/-fkms-v3d,cma-128/' /boot/config.txt # breaks on trixie
fi

## RaspOS cmdline tweaks
if [ -f /boot/cmdline.txt ]; then
  sed -i '$s/$/\ console=tty1\ loglevel=1\ splash\ logo.nologo\ cfg80211.ieee80211_regdom=US\ vt.global_cursor_default=1\ plymouth.ignore-serial-consoles\ console=tty3/' \
    "$(realpath /boot/cmdline.txt)"

  sed -i 's#console=serial0,115200 ##'      "$(realpath /boot/cmdline.txt)"
  sed -i 's#console=/dev/serial0,115200 ##' "$(realpath /boot/cmdline.txt)"
  sed -i 's#console=serial0,9600 ##'        "$(realpath /boot/cmdline.txt)"
  sed -i 's#console=/dev/serial0,9600 ##'   "$(realpath /boot/cmdline.txt)"

  # setterm requires a real terminal; CI often has none. Also TERM may be unset.
  if is_tty && command -v setterm >/dev/null 2>&1; then
    setterm -cursor on >> /etc/issue || true
  else
    echo "[skip] setterm -cursor on (no tty or setterm missing)"
  fi

  echo 'i2c_dev' | tee -a /etc/modules >/dev/null
fi

## Armbian
if [ -f /boot/armbianEnv.txt ]; then
  echo "console=serial" >> /boot/armbianEnv.txt
fi

# Debian GRUB (only meaningful on systems using grub + initramfs tools)
if [ -f /etc/default/grub ] ; then
  install -m0644 -v "$FILE_FOLDER/grub" "/etc/default/grub"
  install -m0644 -v "$FILE_FOLDER/background.png" "/boot/grub/background.png"
  echo FRAMEBUFFER=y >> /etc/initramfs-tools/conf.d/splash

  # These can fail in containerized CI; keep them from killing the build.
  run_if_exists update-initramfs -u || true
  run_if_exists update-grub || true
fi

# Theming of the boot process
install -v "$FILE_FOLDER/ascii_logo.txt" "/etc/motd"
cp -r "$FILE_FOLDER/dreams" "/usr/share/plymouth/themes/"

# Setting default theme may call update-initramfs under the hood in some setups.
run_if_exists plymouth-set-default-theme dreams || true

# Armbian
if [ -f /etc/issue ]; then
  rm -f /etc/issue /etc/issue.net
fi

# Raspbian: intercept keystrokes during boot (we disable)
systemctl_safe disable triggerhappy.service
systemctl_safe disable triggerhappy.socket

install -v -m0644 "$FILE_FOLDER/plymouth-start.service" "/etc/systemd/system/"

install -v -d "/etc/systemd/system/console-setup.service.d"
cat > /etc/systemd/system/console-setup.service.d/override.conf <<'EOF'
[Unit]
After=systemd-tmpfiles-setup.service
EOF

# Swap
if [ -f /etc/dphys-swapfile ]; then
  sed -i 's/CONF_SWAPSIZE=100$/CONF_SWAPSIZE=2048/' /etc/dphys-swapfile || true
fi

#systemctl_safe disable systemd-firstboot.service
