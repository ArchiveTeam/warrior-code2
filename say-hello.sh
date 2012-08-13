#!/bin/bash

tput civis
stty -echo

# On VirtualBox we have port forwarding from localhost on the host,
# but VMware doesn't do that.
IP_ADDRESS=$( ifconfig eth0 | grep -oP "inet addr:[.0-9]+" | grep -oP "[.0-9]+" )
SYSTEM=$( lspci | grep -i system )

if [[ $SYSTEM =~ VirtualBox ]]
then
  sudo sh -c "cat at-splash-640x400-32.fb > /dev/fb0"
else
  echo -e "\033[0;30;47m"
  echo
  echo "  Point your web browser to http://${IP_ADDRESS}:8001/ to manage your warrior."
  bytes=$(( 640 * 355 * 4 ))
  sudo sh -c "cat at-splash-640x400-32.fb | head -c $bytes > /dev/fb0"
  echo -ne "\033[0;00;00m"
fi

