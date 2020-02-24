# Reverse Proxy

**Idea:** Use a global reverse proxy on each machine to share ports efficiently while easily.

## Basic setup

### 0. Prerequisites

- docker
- docker-compose
- port 80 available

### 1. Create a docker network for external connections

Create a network called ``web``.

```bash
$ docker network create web
```

### 2. Deploy this project

```bash
$ git clone https://github.com/johanhenriksson/reverse-proxy
$ cd reverse-proxy
$ sudo docker-compose up
```

### 3. Expose other containers through the traefik reverse proxy

The basic steps are:
- Refer to the external `web` network to be able to communicate with the reverse proxy
- Add routing rules using traefik labels
- Add a hostname for the container to `/etc/hosts`

Example container setup:

```yaml
# docker-compose.yml
# service configuration:
networks:
    - web     # attach to the proxy network
    - default # whatever other networks you want
labels:
    - 'traefik.enabled=true'                        # enable proxying to this container
    - 'traefik.docker.network=web'                  # route to this container over the 'web' network
    - 'traefik.http.frontend.rule=Host:example.dev' # set up whatever routing route you like
    - 'traefik.http.frontend.port=3000'             # containers exposed port
```

### 4. Stop it!

You can easily kill the proxy if you need port 80:

```bash
$ docker stop proxy
```
