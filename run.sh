#!/usr/bin/env bash

ESC="\x1B["
RESET=$ESC"39m"
RED=$ESC"31m"
GREEN=$ESC"32m"
BLUE=$ESC"34m"

if [[ -z ${1} ]]; then
    echo -e "${RED}Missing argument box name.${RESET}"
    exit 0
fi

if [[ "${2}" != "shared" ]]; then
    shared_cmd=""
else
    shared_cmd="-v $(pwd):/root/shared"
fi

box_name=${1}

containers=$(docker ps -aqf "name=${box_name}")

if [[ ! -z "${containers}" ]]; then
    docker start ${box_name} > /dev/null 2>&1
else
    # Create docker container and run in the background
    # Add this if you need to modify anything in /proc:  --privileged 
    docker run -it -d \
        -h ${box_name} \
        --name ${box_name} \
        --privileged \
        $shared \
        syc0de/pwnbox

fi
# Get a shell
echo -e "${GREEN}                         ______               ${RESET}"
echo -e "${GREEN}___________      ___________  /___________  __${RESET}"
echo -e "${GREEN}___  __ \\_ | /| / /_  __ \\_  __ \\  __ \\_  |/_/${RESET}"
echo -e "${GREEN}__  /_/ /_ |/ |/ /_  / / /  /_/ / /_/ /_>  <  ${RESET}"
echo -e "${GREEN}_  .___/____/|__/ /_/ /_//_.___/\\____//_/|_|  ${RESET}"
echo -e "${GREEN}/_/                                by jcalabres  ${RESET}"
echo ""

docker attach ${box_name}
