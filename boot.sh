#!/bin/bash
# A small boot script.
# Pulls the latest code from GitHub, then runs the warrior.

stop() {
  while true
  do
    sleep 120
  done
}

cd /home/warrior/warrior-code2
echo
echo "  ****************************************************************"
echo "  *                                                              *"
echo "  *   Welcome to the ArchiveTeam Warrior                         *"
echo "  *                                                              *"
echo "  *   www.archiveteam.org                                        *"
echo "  *                                                              *"
echo "  ****************************************************************"
echo
echo "      The Warrior Code is launching. Please wait..."
echo
echo "Loading the ArchiveTeam Warrior..."
echo "Updating the warrior code..."

tries=5
delay=1
err=false
while [[ $tries -gt 0 ]]
do
  if git pull
  then
    tries=0
    err=false
  else
    echo
    echo "Waiting for a network connection..."
    sleep $delay

    tries=$(( tries - 1 ))
    delay=$(( delay * 2 ))
    err=true
  fi
done

if $err
then
  echo
  echo "ERROR: Could not update the code. Is your network connection OK?"
  echo "Reboot the machine and try again."
  stop
fi

git show --quiet --pretty="format:Warrior version %h -- %cr"
echo
echo

./warrior-install.sh

rm -rf /data/data
mkdir -p /data/data

mkdir -p /home/warrior/projects

./say-hello.sh

run-warrior \
  --projects-dir /home/warrior/projects \
  --data-dir /data/data \
  --warrior-hq http://warriorhq.archive.org \
  --port 8001 \
  > /dev/tty2
#  2> /dev/tty2

