#!/bin/bash
# This script should install/update the warrior, if necessary.

# Check the seesaw-kit.
echo "Checking for the latest seesaw kit..."
SEESAW_VERSION=$( git ls-remote https://github.com/ArchiveTeam/seesaw-kit.git HEAD | cut -f 1 )
if ! sudo pip freeze | grep -q $SEESAW_VERSION
then
  echo "Upgrading the seesaw kit..."
  sudo pip install -e "git+https://github.com/ArchiveTeam/seesaw-kit.git#egg=seesaw"
else
  echo "No need to upgrade the seesaw kit."
fi

