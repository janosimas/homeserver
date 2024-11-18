# Stacks

In `Stacks` are a set of `docker compose` configurations of multipla applications.

## Notes

- Network

All the stacks use the same network (`internal_network`) to allow routing. This network is created by the `wirewhole` stack but if you're not using it you can just copy the configuration to another stack.

- Labels

Most containers have `labels` to be indexed by `Homepage` and/or `Traefik`.

Removing the labes should not cause any issue unrelated to those services.

### Configurations

## Env file

The first step is to create a `/stacks/.env` file with values in accord to your system. The file `/stacks/.env.sample` can be used as a sample and has some comments.

## Wirewhole

Wirewhole will depend on two configuration files to work:
- `unbound.conf`: that should be copied to `${SERVICE_DATA}/unbound`
- `07-home-server.conf`:  that should be updated with the host local ip and copied to `${SERVICE_DATA}/pihole/etc-dnsmasq.d`

## How to run a stack

The stacks expect the have an already configured network, so you should start with wirewhole or check the notes.

If the `.env` file is created, you can go in the folder of any stack and start it with the command: `docker compose --env-file ../.env up -d`

## General structure

The general structure of the stacks is:
 ```yaml
   <service name>:
    ...
    networks:
      internal_network:
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.<service name>.rule=Host(`<service name>.server.home`)"
      - "traefik.http.routers.<service name>.entrypoints=web"
      - "traefik.http.services.<service name>.loadbalancer.server.port=<service port>"

 ```