log() {
  echo -e "\e[32m["$(date +'%T')"] \e[1m $1 \e[0m"
}

logErr() {
  echo -e "\e[91m ["$(date +'%T')"] ---> $1 \e[0m"
}

# Create caching folder hierarchy to work with this architecture
setupWorkSpace() {
  thisArch=$1
  mkdir -p ./cache/"$thisArch"/stageCache
  mkdir -p ./work/"$thisArch"/rootfs
  #mkdir -p ./work/"$thisArch"/bootfs
  mkdir -p ./release/"$thisArch"
}

# Check if the user run with root privileges
checkRoot() {
  if [ $EUID -ne 0 ]; then
    echo "This tool must be run as root."
    exit 1
  fi
}

mountImageFile() {
  thisArch=$1
  imageFile=$2
  mountOpt=$3
  rootfs=./work/${thisArch}/rootfs

  log "Mounting Image File"

  ## Make sure it's not already mounted
  if [ -n "$(ls -A "$rootfs")" ]; then
    logErr "$rootfs is not empty. Previous failure to unmount?"
    umountImageFile "$1" "$2"
    exit
  fi

  # Mount the image and make the binds required to chroot.
  losetup -f
  partitions=$(kpartx -sav "$imageFile" | cut -d' ' -f3)
  partQty=$(echo "$partitions" | wc -w)
  echo "$partQty partitions detected."

  # mount partition table in /dev/loop
  loopId=$(echo "$partitions" | grep -oh '[0-9]*' | head -n 1)

  if [ "$partQty" == 2 ]; then
    mount $mountOpt -v /dev/mapper/loop"${loopId}"p2 "$rootfs"/
    #if [ ! -d "$rootfs"/boot ]; then mkdir "$rootfs"/boot; fi
    #mount $mountOpt -v /dev/mapper/loop"${loopId}"p1 "$rootfs"/boot/
  elif [ "$partQty" == 1 ]; then
    mount $mountOpt -v /dev/mapper/loop"${loopId}"p1 "$rootfs"/
  else
    log "ERROR: unsupported amount of partitions."
    exit 1
  fi
}

umountImageFile() {
  log "un-Mounting"
  thisArch=$1
  imageFile=$2
  rootfs=./work/${thisArch}/rootfs

  rm -rf "$rootfs"/home/border
  rm -rf "$rootfs"/install-scripts/stageCache/*
  rm -rf "$rootfs"/install-scripts/logs/*
  find "$rootfs"/var/log/ -type f -exec rm -rf {} \;
  rm -rf "$rootfs"/tmp/*

  umount "$rootfs"/etc/resolv.conf
  umount "$rootfs"/dev
  umount "$rootfs"/sys
  umount "$rootfs"/proc
  umount "$rootfs"/tmp
  umount "$rootfs"/install-scripts/stageCache
  umount "$rootfs"/run/shm
  #umount "$rootfs"/boot
  umount "$rootfs"

  kpartx -d "$imageFile"
}

inflateImage() {
  thisArch=$1
  imageLocation=$2
  imageLocationInflated=${imageLocation}-inflated

  if [ ! -f "$imageLocationInflated" ]; then
    log "Inflating OS image to have enough space to build BBN OS. "
    cp -fv "${imageLocation}" "$imageLocationInflated"

    if [ "$BBN_KIND" == "LITE" ] ; then
      log "truncate image to 9G"
      truncate -s "9G" "$imageLocationInflated"
    else
      log "truncate image to 14G"
      truncate -s "14G" "$imageLocationInflated"
    fi
    sync
    sleep 5

    log "resize last partition to 100%"
    partQty=$(fdisk -l "$imageLocationInflated" | grep -o "^$imageLocationInflated" | wc -l)
    parted -l "$imageLocationInflated"
    parted "$imageLocationInflated" --script "resizepart $partQty 100%"
    fdisk -l "$imageLocationInflated"

    log "Resize the filesystem to fit the partition."
    loopId=$(kpartx -sav "$imageLocationInflated" | cut -d" " -f3 | grep -oh '[0-9]*' | head -n 1)
    sleep 3
    ls -l /dev/mapper/

    e2fsck -y -f /dev/mapper/loop"${loopId}"p"$partQty"
    resize2fs /dev/mapper/loop"${loopId}"p"$partQty"
    kpartx -d "$imageLocationInflated"
  else
    log "Using Ready to build image from cache"
  fi
}

function addLysmarineScripts() {
  thisArch=$1
  rootfs=./work/${thisArch}/rootfs
  log "copying lysmarine on the image"
  ls "$rootfs"
  cp -r ./install-scripts "${rootfs}"/
  chmod 0775 "${rootfs}"/install-scripts/install.sh
}
