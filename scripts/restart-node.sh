#!/bin/bash


SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
LAST_LINE="1000"
FIND_ERRORS="
Thread 'tokio-runtime-worker' panicked at 'Storage root must match that calculated.'
"
IFS=$'\n'

docker-compose -f ${SCRIPT_DIR}/../docker-compose.yml logs --tail ${LAST_LINE} > pontem-node.log

# set -x
for error in ${FIND_ERRORS}; do
    if grep -iq "${error}" pontem-node.log; then
        echo 'The error was found.'
        docker-compose -f ${SCRIPT_DIR}/../docker-compose.yml restart
    fi
done

rm pontem-node.log
