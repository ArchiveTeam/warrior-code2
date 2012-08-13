#!/bin/bash
# This script should install/update the warrior, if necessary.

# Check the seesaw-kit.
echo "Checking for the latest seesaw kit..."
SEESAW_VERSION=$( git ls-remote https://github.com/ArchiveTeam/seesaw-kit.git HEAD | cut -f 1 )
if ! sudo pip freeze | grep -q $SEESAW_VERSION
then
  echo "Upgrading the seesaw kit..."
  sudo pip install -e "git+https://github.com/ArchiveTeam/seesaw-kit.git#egg=seesaw"
else
  echo "No need to upgrade the seesaw kit."
fi

# Check for splash screen support.
if [ ! -f /etc/modprobe.d/uvesafb.conf ]
then
  echo "Installing framebuffer..."
  sudo apt-get update
  sudo apt-get -y install v86d
  sudo sh -c 'echo "uvesafb" >> /etc/modules'
  sudo sh -c 'echo "options uvesafb mode_option=640x400-32 scroll=ywrap" > /etc/modprobe.d/uvesafb.conf'
  sudo modprobe uvesafb
fi

