#!/bin/bash

tput civis
stty -echo

# On VirtualBox we have port forwarding from localhost on the host,
# but VMware doesn't do that.
IP_ADDRESS=$( ifconfig eth0 | grep -oP "inet addr:[.0-9]+" | grep -oP "[.0-9]+" )
SYSTEM=$( lspci | grep -i system )

echo -e "\033[0;30;47m"
echo
echo "  The warrior has successfully started up."
echo

if [[ $SYSTEM =~ VirtualBox ]]
then
  echo "  Point your web browser to http://localhost:8001/ to manage your warrior."
  sudo sh -c "cat at-splash-640x400-32.fb > /dev/fb0"
else
  echo "  Point your web browser to http://${IP_ADDRESS}:8001/ to manage your warrior."
  bytes=$(( 640 * 355 * 4 ))
  sudo sh -c "cat at-splash-640x400-32.fb | head -c $bytes > /dev/fb0"
fi

echo -ne "\033[0;00;00m"

