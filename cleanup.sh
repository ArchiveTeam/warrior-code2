#!/bin/bash
rm -rf /var/cache/apt/* \
       /var/cache/debconf/* \
       /var/lib/apt/* \
       /var/lib/aptitude/* \
       /var/log/* \
       /usr/share/aptitude/* \
       /usr/share/doc/* \
       /usr/share/man/*

find /usr/share/locale/ -mindepth 1 -maxdepth 1 -type d ! -name "en*" -exec rm -rf {} \;

chmod 777 /data

# echo "Zero-filling /data"
# dd if=/dev/zero of=/data/fill bs=10M
# rm -f /data/fill

echo "Zero-filling /"
dd if=/dev/zero of=/root/fill bs=10M
rm -f /root/fill

