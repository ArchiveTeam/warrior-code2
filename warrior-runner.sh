#!/bin/bash

WARRIOR=run-warrior2

if type python3 > /dev/null 2>&1 && type run-warrior3 > /dev/null 2>&1 ; then
  WARRIOR=run-warrior3
fi

while [ ! -f /dev/shm/ready-for-warrior ]
do
  sleep 1
done

cd /home/warrior/warrior-code2

$WARRIOR \
  --projects-dir /home/warrior/projects \
  --data-dir /data/data \
  --warrior-hq http://warriorhq.archiveteam.org \
  --port 8001 \
  --real-shutdown
