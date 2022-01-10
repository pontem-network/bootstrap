#!/bin/bash

while true; do
    LAST_LINE="200"
    declare -a FIND_ERRORS=("Thread 'tokio-runtime-worker' panicked at 'Storage root must match that calculated.'")
    #IFS=$'\n'

    docker logs pontem-node -n ${LAST_LINE} >& pontem-node.log

    #set -x
    for error in "${FIND_ERRORS[@]}"; do
        if grep -iq "${error}" pontem-node.log; then
            echo -e "The error was found: \e[1;31m*** ${error} ***\e[0m"
            #echo "${error}"
            docker container restart pontem-node
            echo -e "\e[1;32mThe node was restarted at $(date '+%F %H:%M')\e[0m"
        fi
    done

    rm pontem-node.log
    sleep 5m
done