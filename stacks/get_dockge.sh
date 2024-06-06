#!/bin/bash
set -o nounset -o pipefail -o errexit

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOCKGE_PORT=5001
COMPOSE_FILE=compose.yaml

curl "https://dockge.kuma.pet/compose.yaml?port=${DOCKGE_PORT}&stacksPath=$SCRIPT_DIR" --output "${COMPOSE_FILE}"

sed -i -e 's#./data:/app/data#${SERVICE_DATA}/dockge/data:/app/data#g' ${COMPOSE_FILE}

echo """
    labels:
      - homepage.group=System
      - homepage.name=Dockge
      - homepage.icon=dockge.png
      - homepage.href=http://${INTERNAL_ADDR}:${DOCKGE_PORT}/
      - homepage.description=Docker compose manager
""" >> "${COMPOSE_FILE}"

if [[ "${SERVICE_DATA}" ]] && grep -Fq '${SERVICE_DATA}/dockge/data:' ${COMPOSE_FILE}; then
    docker compose up -d
else
    echo
    echo "> Error initializing Dockge!"
    echo "> Check the generated ${COMPOSE_FILE} and your environment variables!"
    echo
fi
