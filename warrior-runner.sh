#!/bin/bash

PROJECTS_DIR="/home/warrior/projects"
DATA_DIR="/data/data"
CODE_DIR="`dirname $0`"

while [ ! -f /dev/shm/ready-for-warrior ]
do
  sleep 1
done

if [ ! -f "$PROJECTS_DIR/config.json" ]
then
  wget -T 2 -t 0 -q -O "$PROJECTS_DIR/config.json" http://169.254.169.254/latest/user-data
fi

cd "$CODE_DIR"

run-warrior \
  --projects-dir "$PROJECTS_DIR" \
  --data-dir "$DATA_DIR" \
  --warrior-hq http://warriorhq.archiveteam.org \
  --port 8001 \
  --real-shutdown

