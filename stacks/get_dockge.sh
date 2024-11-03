#!/bin/bash
set -o nounset -o pipefail -o errexit

STACKS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOCKGE_PORT=5001
COMPOSE_FILE="${STACKS_DIR}/compose.yaml"

curl "https://dockge.kuma.pet/compose.yaml?port=${DOCKGE_PORT}&stacksPath=$STACKS_DIR" --output "${COMPOSE_FILE}"

sed -i -e 's#./data:/app/data#${SERVICE_DATA}/dockge/data:/app/data#g' ${COMPOSE_FILE}

echo """
    env_file:
      - path: ${STACKS_DIR}/.env
    labels:
      - homepage.group=System
      - homepage.name=Dockge
      - homepage.icon=dockge.png
      - homepage.href=http://dockge.mistborn/
      - homepage.description=Docker compose manager
      - "traefik.enable=true"
      - "traefik.http.routers.dockge-http.rule=Host(`dockge.mistborn`)"
      - "traefik.http.routers.dockge-http.entrypoints=web"
      - "traefik.http.routers.dockge-http.middlewares=mistborn_auth@file"
      - "traefik.http.routers.dockge-https.rule=Host(`dockge.mistborn`)"
      - "traefik.http.routers.dockge-https.entrypoints=websecure"
      - "traefik.http.routers.dockge-https.middlewares=mistborn_auth@file"
      - "traefik.http.routers.dockge-https.tls.certresolver=basic"
      - "traefik.http.services.dockge-service.loadbalancer.server.port=${DOCKGE_PORT}"
networks:
  default:
    name: mistborn_default
    external: true""" >> "${COMPOSE_FILE}"

if [[ "${SERVICE_DATA}" ]] && grep -Fq '${SERVICE_DATA}/dockge/data:' ${COMPOSE_FILE}; then
    # docker compose up -d
    echo foo
else
    echo
    echo "> Error initializing Dockge!"
    echo "> Check the generated ${COMPOSE_FILE} and your environment variables!"
    echo
fi
