#!/bin/bash
# This script should install/update the warrior, if necessary.

PIP=pip
REBOOT_NEEDED=false

if type pip3 > /dev/null 2>&1; then
  PIP=pip3
fi

echo "Using '$PIP' for pip."


# Upgrade pip for 2012 warriors
if pip --version | grep "pip 1.2.1 from /usr/local/lib/python2.6/dist-packages"; then
    echo "Upgrading pip..."

    mkdir -p /tmp/pip/
    curl http://warriorhq.archiveteam.org/downloads/pip/get-pip.py > /tmp/pip/get-pip.py
    curl http://warriorhq.archiveteam.org/downloads/pip/sha1sum.txt > /tmp/pip/sha1sum.txt
    grep get-pip.py /tmp/pip/sha1sum.txt > /tmp/pip/sha1sum_get_pip.txt

    if (cd /tmp/pip/ && sha1sum --check sha1sum_get_pip.txt); then
        sudo python /tmp/pip/get-pip.py
        echo "Reinstalling seesaw..."
        sudo pip install seesaw --ignore-installed
        REBOOT_NEEDED=true
    else
        echo "Pip download could not be validated!"
        echo "You may need to inspect the problem and reboot manually."
        echo "Pausing for 60 seconds before continuing..."
        sleep 60
    fi
fi


# Upgrade old setuptools to fix DistributionNotFound after new pip install
if python --version 2>&1 | grep "Python 2." &&
python -c "import setuptools; print 'v'+setuptools.__version__" | grep "v0.6"
then
    echo "Upgrading setuptools..."
    sudo pip install setuptools --upgrade
    REBOOT_NEEDED=true
fi


if "$REBOOT_NEEDED"; then
    echo "Done! Rebooting in 60 seconds..."
    sudo shutdown -r 1
fi

# Check the seesaw-kit.
echo "Checking for the latest seesaw kit..."
seesaw_branch=$( git rev-parse --abbrev-ref HEAD )
SEESAW_VERSION=$( git ls-remote https://github.com/ArchiveTeam/seesaw-kit.git ${seesaw_branch} | cut -f 1 )
if ! sudo $PIP freeze | grep -q $SEESAW_VERSION
then
  echo "Upgrading the seesaw kit..."
  if ! sudo $PIP install -e "git+https://github.com/ArchiveTeam/seesaw-kit.git@${seesaw_branch}#egg=seesaw" --upgrade
  then
    # sometimes pip's git pull fails because the local repository
    # is invalid. reset and try again
    sudo rm -rf "/home/warrior/warrior-code2/src/seesaw"
    sudo $PIP install -e "git+https://github.com/ArchiveTeam/seesaw-kit.git@${seesaw_branch}#egg=seesaw" --upgrade
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

