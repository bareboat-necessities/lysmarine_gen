#!/bin/bash -xe
{
  source lib.sh

  MY_CPU_ARCH=$1
  LYSMARINE_VER=$2
  BBN_KIND=$3
  DOCKER_CONTAINER_ID=$4

  thisArch="debian"
  cpuArch="armhf"

  zipName="bareboat-necessities/lysmarine_gen/releases/download/vTest/M5_CoreMP135_debian12_20240628.7z"
  imageSource="https://github.com/${zipName}"

  checkRoot

  # Create caching folder hierarchy to work with this architecture.
  setupWorkSpace $thisArch

  # Download the official image
  log "Downloading official image from internet."
  myCache=./cache/$thisArch
  wget -P $myCache/ $imageSource
  7z e -aoa -o$myCache/ $myCache/"$(basename $zipName)"
  rm $myCache/"$(basename $zipName)"

  # Copy image file to work folder add temporary space to it.
  imageName=$(
    cd $myCache
    ls *.img
    cd ../../
  )

#  cp $myCache/"$imageName" ./work/$thisArch/"$imageName"
  inflateImage $thisArch $myCache/"$imageName"

  # copy ready image from cache to the work dir
  cp -fv --reflink=auto --sparse=always $myCache/"$imageName"-inflated ./work/$thisArch/"$imageName"

  # Mount the image and make the binds required to chroot.
  mountImageFile $thisArch ./work/$thisArch/"$imageName"

  # Copy the lysmarine and origin OS config files in the mounted rootfs
  addLysmarineScripts $thisArch

  mkRoot=work/${thisArch}/rootfs
  ls -l $mkRoot

  mkdir -p ./cache/${thisArch}/stageCache
  mkdir -p $mkRoot/install-scripts/stageCache
  mkdir -p /run/shm
  mkdir -p $mkRoot/run/shm
  mount -o bind /etc/resolv.conf $mkRoot/etc/resolv.conf
  mount -o bind /dev $mkRoot/dev
  mount -o bind /sys $mkRoot/sys
  mount -o bind /proc $mkRoot/proc
  mount -o bind /tmp $mkRoot/tmp
  mount --rbind $myCache/stageCache $mkRoot/install-scripts/stageCache
  mount --rbind /run/shm $mkRoot/run/shm
  chroot $mkRoot /bin/bash -xe <<EOF
    set -x; set -e; cd /install-scripts; export LMBUILD="debian"; export BBN_KIND="$BBN_KIND"; export DOCKER_CONTAINER_ID="$DOCKER_CONTAINER_ID"; ls; chmod +x *.sh; ./install.sh 0 2 4 a; exit
EOF

  # Unmount
  umountImageFile $thisArch ./work/$thisArch/"$imageName"

  ls -l ./work/$thisArch/"$imageName"

  # Renaming the OS and moving it to the release folder.
  BBN_IMG=bbn-venus-sim-coremp135_"${LYSMARINE_VER}"-${thisArch}-${cpuArch}.img
  cp -v -l ./work/$thisArch/"$imageName" ./release/$thisArch/"$BBN_IMG"

  exit 0
}
