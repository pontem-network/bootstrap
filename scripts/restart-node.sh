#!/bin/bash

while true; do
    LAST_LINE="200"
    FIND_ERRORS="
    No Nimbus keys available. We will not be able to author
    "
    IFS=$'\n'

    docker logs pontem-node -n ${LAST_LINE} >& pontem-node.log

    # set -x
    for error in ${FIND_ERRORS}; do
        if grep -iq "${error}" pontem-node.log; then
            echo 'The error was found.'
            docker container restart pontem-node
        fi
    done

    rm pontem-node.log
    sleep 5m
done