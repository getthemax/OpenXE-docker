# OpenXE-docker

## Quick start

```bash
git clone https://github.com/getthemax/OpenXE-docker.git
cd OpenXE-docker
chmod +x install.sh
./install.sh
```

### important

***install.sh will create user www-data if not exists, the script should work on Debian based distros
The image currently is based on debian bookwork, therefore the user www-data is needed due to the limits from bind mounts***

SSL, i recommend Traefik or Nginx Proxy Manager, for Traefik use docker-compose-traefik.yaml, before you start adjust compose file according to your config

This git uses [Bind mounts](https://docs.docker.com/engine/storage/bind-mounts/), the OpenXE "app" folder is mounted into the container, for better maintenance

### Traefik

For traefik use docker-compose-traefik.yaml and adapt it according to your needs
