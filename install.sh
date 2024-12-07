#!/usr/bin/bash

#set -x

TAG="V.1.12" ### OpenXE Version
DIR="app" ### OpenXE docroot, DO NOT CHANGE

### check if app folder exists
if [ -d "$DIR" ]; then
  echo "app folder found"
  exit 1
fi

wget https://github.com/OpenXE-org/OpenXE/archive/refs/tags/${TAG}.tar.gz
tar -xvf ${TAG}.tar.gz
mv OpenXE-${TAG} app
rm ${TAG}.tar.gz

# check if user www-data exists
if getent passwd "www-data" > /dev/null; then
  echo "User www-data exists"
else
  adduser --uid 33 --gid 33 --home /var/www --shell /usr/sbin/nologin --no-create-home
fi

chown -R www-data:www-data app

### thx dakhnod
sed -i 's/\$setup\[2\]\[\x27fields\x27\]\[\x27WFdbhost\x27\]\[\x27default\x27\] = ".*";/$setup[2]['\''fields'\'']['\''WFdbhost'\'']['\''default'\''] = "mariadb";/' app/www/setup/setup.conf.php 
sed -i 's/\$setup\[2\]\[\x27fields\x27\]\[\x27WFdbname\x27\]\[\x27default\x27\] = ".*";/$setup[2]['\''fields'\'']['\''WFdbname'\'']['\''default'\''] = "openxe";/' app/www/setup/setup.conf.php
sed -i 's/\$setup\[2\]\[\x27fields\x27\]\[\x27WFdbuser\x27\]\[\x27default\x27\] = ".*";/$setup[2]['\''fields'\'']['\''WFdbuser'\'']['\''default'\''] = "openxe";/' app/www/setup/setup.conf.php

docker compose build --no-cache

docker compose up
