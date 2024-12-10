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

# OS Check
if hostnamectl status | grep -q "CentOS|Rocky|AlmaLinux"; then

  if getent passwd "nobody" > /dev/null; then  
    echo "User nobody exists"
    chown -R nobody:nobody app
  else
    addgroup --gid 65534 nobody
    adduser --uid 65534 --gid 65534 --home /nonexistent --shell /sbin/nologin --no-create-home nobody
    chown -R nobody:nobody app
  fi

elif hostnamectl status | grep -q "Debian|Ubuntu"; then

  if getent passwd "nobody" > /dev/null; then  
    echo "User nobody exists"
    chown -R nobody:nogroup app
  else
    addgroup --gid 65534 nogroup
    adduser --uid 65534 --gid 65534 --home /nonexistent --shell /usr/sbin/nologin --no-create-home nobody
    chown -R nobody:nogroup app
  fi

fi

### thx dakhnod
sed -i 's/\$setup\[2\]\[\x27fields\x27\]\[\x27WFdbhost\x27\]\[\x27default\x27\] = ".*";/$setup[2]['\''fields'\'']['\''WFdbhost'\'']['\''default'\''] = "mariadb";/' app/www/setup/setup.conf.php 
sed -i 's/\$setup\[2\]\[\x27fields\x27\]\[\x27WFdbname\x27\]\[\x27default\x27\] = ".*";/$setup[2]['\''fields'\'']['\''WFdbname'\'']['\''default'\''] = "openxe";/' app/www/setup/setup.conf.php
sed -i 's/\$setup\[2\]\[\x27fields\x27\]\[\x27WFdbuser\x27\]\[\x27default\x27\] = ".*";/$setup[2]['\''fields'\'']['\''WFdbuser'\'']['\''default'\''] = "openxe";/' app/www/setup/setup.conf.php

docker compose build --no-cache

docker compose up