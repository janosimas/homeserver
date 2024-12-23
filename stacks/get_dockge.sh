#!/bin/bash
set -o nounset -o pipefail -o errexit

source .env

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
      - homepage.href=http://dockge.server.home/
      - homepage.description=Docker compose manager
      - traefik.enable=true
      - traefik.http.routers.dockge.rule=Host(\`dockge.server.home\`)
      - traefik.http.routers.dockge.entrypoints=web
      - traefik.http.services.dockge.loadbalancer.server.port=5001
    networks:
      internal_network:

networks:
  internal_network:
    external: true
      """ >> "${COMPOSE_FILE}"

if [[ "${SERVICE_DATA}" ]] && grep -Fq '${SERVICE_DATA}/dockge/data:' ${COMPOSE_FILE}; then
    docker compose up -d
else
    echo
    echo "> Error initializing Dockge!"
    echo "> Check the generated ${COMPOSE_FILE} and your environment variables!"
    echo
fi
