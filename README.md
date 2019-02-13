# Reverse Proxy

**Idea:** Use a global reverse proxy on each machine to share ports efficiently while easily being able to easily move between production and local environments. Also provides a general solution for HTTPS/SSL for all containers. In the simplest case, the only configuration difference between a local and a production environment would be the hostname.

## Basic setup

### 0. Prerequisites

- Docker
- Docker Compose
- Ports 80 and 443 available

### 1. Create a docker network for external connections

It must be called ``web``

```
docker network create web
```

### 2. Deploy this project

```
git clone https://github.com/johanhenriksson/reverse-proxy
cd reverse-proxy
sudo docker-compose up
```

On externally reachable machines, also delete (or rename) the docker-compose override to enable https.

```
rm docker-compose.override.yml
```

### 3. Expose other containers through the traefik reverse proxy

The basic steps are:
- Refer to the external ``web`` network to be able to communicate with the reverse proxy
- Add routing rules using traefik labels
- Use environment variables to define per-environment settings like the host name.

Example container setup:

```
# .env (development environment)
HOSTNAME=server.localhost
```

```
# .env (production environment)
HOSTNAME=server.com
```

```
# docker-compose.yml
version: '2'
networks:
    # add a reference to the external 'web' network
    web:
        external: true
services:
    server:
        image: 'some_server'
        networks:
            - 'web'     # exposed containers must be on the external network
            - 'default' # default compose network
        labels:
            - 'traefik.enabled=true'                        # enable proxying to this container
            - 'traefik.docker.network=web'                  # route to this container over the 'web' network
            - 'traefik.http.frontend.rule=Host:${HOSTNAME}' # set up whatever routing route you like
            - 'traefik.http.frontend.port=3000'             # containers exposed port
```