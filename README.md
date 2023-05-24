# homeserver

This repository is a collection of scripts and configuration files to help setting a homeserver.

**IMPORTANT**: These are experiments and should not be considered production ready or safe

## Containers

The setup for the containers can be found in the `compose`.

The containers can be started in the background using:
```bash
docker compose -f <config.yml> up -d
```

An exception is `wirehole`, that need that `config/unbound.conf` is copied to `${DATADIR}/unbound`
