#!/bin/bash
set -o nounset -o pipefail -o errexit

function help() {
    # Display Help
    echo "Start a service"
    echo
    echo "This script requires an .env file, check the 'ansible' folder to generate one"
    echo
    echo "Syntax: $0 <service name>"
    echo "available services:"
    FILES="compose/*.yml"
    for filepath in $FILES; do
        filename=$(basename $filepath)
        echo "  ${filename%.*}"
    done
    echo
}

while getopts ":h" option; do
    case $option in
    h) # display Help
        help $0
        exit
        ;;
    esac
done

if [ $# -ne 1 ]; then
    echo "[Error] Incorrect number of parameters"
    echo
    help "${0}"
    exit
fi

if [[ ! -f ".env" ]]; then
    echo "[Error] .env file not found"
    help "${0}"
fi

# Load all variables from .env and export them all for Ansible to read
set -o allexport
source "$(dirname "$0")/.env"
set +o allexport

# Run compose
# exec docker compose
if [[ -f "compose/${1}.yml" ]]; then
    docker compose -f "compose/${1}.yml" up -d
else
    echo "[Error] Service '${1}' not found"
    help "${0}"
fi
