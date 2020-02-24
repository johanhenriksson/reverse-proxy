# Reverse Proxy

**Idea:** Use a global reverse proxy on each machine to share ports efficiently while easily.

## Basic setup

### 0. Prerequisites

- docker
- docker-compose
- port 80 available

### 1. Create a docker network for proxied containers

Create a network called ``web``.

```bash
$ docker network create web
```

### 2. Deploy this project locally

```bash
$ git clone https://github.com/johanhenriksson/reverse-proxy
$ cd reverse-proxy
$ sudo docker-compose up
```

### 3. Expose other containers through the reverse proxy

The basic steps are:
- Add container to the external `web` network to be able to communicate with the reverse proxy
- Add matching rules using traefik labels. See https://docs.traefik.io/v1.7/basics/#matchers
- Add a hostname for the container to `/etc/hosts`

Example container setup:

```yaml
# docker-compose.yml
# service configuration:
# ...
networks:
  web:
    external: true
# ...
services:
  example:
    # ...
    networks:
      - web     # attach to the proxy network
      - default # whatever other networks you want
    labels:
      - 'traefik.enabled=true'                        # enable proxying to this container
      - 'traefik.docker.network=web'                  # route to this container using the 'web' network
      - 'traefik.http.frontend.rule=Host:example.dev' # set up whatever routing route you like
      - 'traefik.http.frontend.port=3000'             # container listening port
```

Example `/etc/hosts` rule:
```
127.0.0.1 example.dev
```

That's it. Your container is now available at http://example.dev

### 4. Stop it!

You can easily kill the proxy if you need port 80:

```bash
$ docker stop proxy
```
