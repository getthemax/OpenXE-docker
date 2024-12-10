#!/usr/bin/bash

#set -x

TAG="V.1.12" ### OpenXE Version

### do not change anything after this line

DIR="app" ### OpenXE docroot, DO NOT CHANGE
USER="65534" ### User ID, DO NOT CHANGE
GROUP="65534" ### Group ID , DO NOT CHANGE

### check if app folder exists
if [ -d "$DIR" ]; then
  echo "app folder found"
  exit 1
fi

wget https://github.com/OpenXE-org/OpenXE/archive/refs/tags/${TAG}.tar.gz
tar -xvf ${TAG}.tar.gz
mv OpenXE-${TAG} app
rm ${TAG}.tar.gz

# user check
if getent passwd | cut -d: -f3 | grep -q "^$USER$"; then
  echo "found"                                            
else
  echo "user not found"                                   
fi

# group check
if getent group "$GROUP" >/dev/null 2>&1; then
  echo "found"                                           
else
  echo "group not found"                                 
fi

### thx dakhnod
sed -i 's/\$setup\[2\]\[\x27fields\x27\]\[\x27WFdbhost\x27\]\[\x27default\x27\] = ".*";/$setup[2]['\''fields'\'']['\''WFdbhost'\'']['\''default'\''] = "mariadb";/' app/www/setup/setup.conf.php 
sed -i 's/\$setup\[2\]\[\x27fields\x27\]\[\x27WFdbname\x27\]\[\x27default\x27\] = ".*";/$setup[2]['\''fields'\'']['\''WFdbname'\'']['\''default'\''] = "openxe";/' app/www/setup/setup.conf.php
sed -i 's/\$setup\[2\]\[\x27fields\x27\]\[\x27WFdbuser\x27\]\[\x27default\x27\] = ".*";/$setup[2]['\''fields'\'']['\''WFdbuser'\'']['\''default'\''] = "openxe";/' app/www/setup/setup.conf.php

docker compose build --no-cache

docker compose up