#!/bin/bash
# A small boot script.
# Prepares and runs the warrior.
# This script starts after boot.sh has updated the code.

stop() {
  while true
  do
    sleep 120
  done
}
./warrior-install.sh
sudo ./make-data-disk.sh

mkdir -p /home/warrior/projects

touch /dev/shm/ready-for-warrior

./say-hello.sh

stop

