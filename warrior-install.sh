#!/bin/bash
# This script should install/update the warrior, if necessary.

PIP=pip

if type pip3 > /dev/null 2>&1 then
  PIP=pip3
fi

echo "Using '$PIP' for pip."

# Check the seesaw-kit.
echo "Checking for the latest seesaw kit..."
seesaw_branch=$( git rev-parse --abbrev-ref HEAD )
SEESAW_VERSION=$( git ls-remote https://github.com/ArchiveTeam/seesaw-kit.git ${seesaw_branch} | cut -f 1 )
if ! sudo $PIP freeze | grep -q $SEESAW_VERSION
then
  echo "Upgrading the seesaw kit..."
  if ! sudo $PIP install -e "git+https://github.com/ArchiveTeam/seesaw-kit.git@${seesaw_branch}#egg=seesaw"
  then
    # sometimes pip's git pull fails because the local repository
    # is invalid. reset and try again
    sudo rm -rf "/home/warrior/warrior-code2/src/seesaw"
    sudo $PIP install -e "git+https://github.com/ArchiveTeam/seesaw-kit.git@${seesaw_branch}#egg=seesaw"
  fi
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

# Remove the old /data mount settings
if grep -qs "/dev/sdb1 /data" /etc/fstab
then
  echo "Disabling /data auto-mount..."
  sudo sed --in-place -r "s/\/dev\/sdb1 \/data ext3 noatime 0 0//" /etc/fstab
fi

# Install DNS caching
if [ ! -f /etc/dnsmasq.conf ]
then
  sudo apt-get update
  sudo apt-get -y install dnsmasq
  sudo sh -c 'echo "listen-address=127.0.0.1" > /etc/dnsmasq.conf'
  sudo sed --in-place -r "s/^#prepend domain-name-servers 127.0.0.1;/prepend domain-name-servers 127.0.0.1;/" /etc/dhcp/dhclient.conf
  sudo dhclient
  sudo /etc/init.d/dnsmasq restart
fi

# Fix a mistake with relative filenames
rm -rf /home/warrior/warrior-code2/data

# Disable mlocate
sudo rm -f /etc/cron.daily/mlocate

