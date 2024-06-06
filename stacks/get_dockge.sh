#!/bin/bash
set -o nounset -o pipefail -o errexit

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOCKGE_PORT=5001

curl "https://dockge.kuma.pet/compose.yaml?port=${DOCKGE_PORT}&stacksPath=$SCRIPT_DIR" --output compose.yaml

sed -i -e 's#./data:/app/data#${SERVICE_DATA}/dockge/data:/app/data#g' compose.yaml

if [[ "${SERVICE_DATA}" ]] && grep -Fq '${SERVICE_DATA}/dockge/data:' compose.yaml; then
    # docker compose up -d
    echo foo
else
    echo
    echo "> Error initializing Dockge!"
    echo "> Check the generated compose.yaml and your environment variables!"
    echo
fi
