#!/usr/bin/bash

#set -x

VERSION="git" ### git or stable

### do not change anything after this line

DIR="app" ### OpenXE docroot, DO NOT CHANGE
USER="65534" ### User ID, DO NOT CHANGE
GROUP="65534" ### Group ID , DO NOT CHANGE
REPO_URL="https://api.github.com/repos/OpenXE-org/OpenXE/releases/latest"

### check if app folder exists
if [ -d "$DIR" ]; then
  echo "app folder found"
  exit 1
fi

# user check
if getent passwd | cut -d: -f3 | grep -q "^$USER$"; then
  echo "user found"
else
  echo "user not found"
  exit 1
fi

# group check
if getent group "$GROUP" >/dev/null 2>&1; then
  echo "group found"
else
  echo "group not found"
  exit 1
fi

# download stable or git openxe
if [ "$VERSION" == "git" ]; then
  git clone https://github.com/OpenXE-org/OpenXE
  mv OpenXE app
else
  # checkout latest stable                           
  if curl -s "$REPO_URL" > /dev/null; then
    VERSION=$(curl -s "$REPO_URL" | jq -r '.tag_name')
    wget https://github.com/OpenXE-org/OpenXE/archive/refs/tags/${VERSION}.tar.gz
    tar -xvf ${VERSION}.tar.gz
    mv OpenXE-${VERSION} app
    rm ${VERSION}.tar.gz
  fi
fi

chown -R $USER:$GROUP app

### thx dakhnod
sed -i 's/\$setup\[2\]\[\x27fields\x27\]\[\x27WFdbhost\x27\]\[\x27default\x27\] = ".*";/$setup[2]['\''fields'\'']['\''WFdbhost'\'']['\''default'\''] = "openxedb";/' app/www/setup/setup.conf.php 
sed -i 's/\$setup\[2\]\[\x27fields\x27\]\[\x27WFdbname\x27\]\[\x27default\x27\] = ".*";/$setup[2]['\''fields'\'']['\''WFdbname'\'']['\''default'\''] = "openxe";/' app/www/setup/setup.conf.php
sed -i 's/\$setup\[2\]\[\x27fields\x27\]\[\x27WFdbuser\x27\]\[\x27default\x27\] = ".*";/$setup[2]['\''fields'\'']['\''WFdbuser'\'']['\''default'\''] = "openxe";/' app/www/setup/setup.conf.php

docker compose build --no-cache

docker compose up