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

if [ -n "$DOCKER" ]
then
  sudo mkdir -p /data/data && sudo chown -R warrior: /data
else
  sudo ./make-data-disk.sh
fi

mkdir -p /home/warrior/projects

touch /dev/shm/ready-for-warrior

./say-hello.sh

if [ -z "$DOCKER" ]
then
  stop
fi

