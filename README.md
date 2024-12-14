# OpenXE-docker

Quick way to run OpenXE within docker

[OpenXE - Das freie ERP System](https://openxe.org/)

## Quick start stable version

```bash
git clone https://github.com/getthemax/OpenXE-docker.git
cd OpenXE-docker
chmod +x install.sh
./install.sh
```

for the latest version, open install.sh and change the VERSION to git

### Important

**install.sh checks if user/group nobody nogroup exists
The user/group nobody nogroup are nessessary, due to the limits from bind mounts**

**Possible Erros:**
**user not found**\
**create user nobody**

**group not found**\
**create group nogroup for Debian based Distros, nobody for RedHat based distros**

Run install.sh again

### SSL

i recommend Traefik or Nginx Proxy Manager, for Traefik use docker-compose-traefik.yaml, before you start adjust compose file according to your config
