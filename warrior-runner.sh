#!/bin/bash

while ! -f /dev/shm/ready-for-warrior
do
  sleep 1
done

cd /home/warrior/warrior-code2

run-warrior \
  --projects-dir /home/warrior/projects \
  --data-dir /data/data \
  --warrior-hq http://warriorhq.archive.org \
  --port 8001

