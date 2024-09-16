#!/bin/bash
#
#  Command Line Interface to start all services associated with the Smart Health PoC
#  For this example the commands are merely a convenience script to run docker-compose
#

set -e

ORION="http://orion:1026/version"
CONTEXT="http://context/user-context.jsonld"
CORE_CONTEXT="https://uri.etsi.org/ngsi-ld/v1/ngsi-ld-core-context-v1.6.jsonld"
USAGE_HELP="[create|start|stop]"

dockerCmd="docker compose"
build=""

if (( $# == 2 )); then
    dockerCmd="docker-compose"
fi

if (( $# < 1 )); then
    echo "Illegal number of parameters"
    echo "usage: services ${USAGE_HELP}"
    exit 1
fi

pause(){
    printf " "
    count="$1"
    [ "$count" -gt 59 ] && printf "Waiting one minute " || printf " Waiting a few seconds ";
    while [ "$count" -gt 0 ]
    do
        printf "."
        sleep 3
        count=$((count - 3))
    done
    echo ""
}

getHeartbeat(){
    eval "response=$(docker run --network fiware_fiware-health-poc --rm quay.io/curl/curl:${CURL_VERSION} -s -o /dev/null -w "%{http_code}" "$1")"
}

waitForOrion () {
    echo -e "\n⏳ Waiting for \033[1;34mOrion-LD\033[0m to be available\n"

    while ! [ `docker inspect --format='{{.State.Health.Status}}' fiware-orion-ld` == "healthy" ]
    do
        echo -e "\nContext Broker HTTP state: ${response} (waiting for 200)"
        pause 6
        getHeartbeat "${ORION}"
    done
}

waitForCoreContext () {
    echo -e "\n⏳ Checking availability of \033[1m core @context\033[0m from ETSI\n"
    eval "response=$(docker run --rm quay.io/curl/curl:${CURL_VERSION} -s -o /dev/null -w "%{http_code}" "$CORE_CONTEXT")"
    while [ "${response}" -eq 000 ]
    do
        echo -e "\n@context HTTP state: ${response} (waiting for 200)"
        pause 3
        eval "response=$(docker run --rm quay.io/curl/curl:${CURL_VERSION} -s -o /dev/null -w "%{http_code}" "$CORE_CONTEXT")"
    done
}

waitForUserContext () {
    echo -e "\n⏳ Waiting for user \033[1m@context\033[0m to be available\n"
    getHeartbeat "${CONTEXT}"
    while [ "${response}" -eq 000 ]
    do
        echo -e "\n@context HTTP state: ${response} (waiting for 200)"
        pause 3
        getHeartbeat "${CONTEXT}"
    done
}

waitForMongo () {
    echo -e "\n⏳ Waiting for \033[1mMongoDB\033[0m to be available\n"
    while ! [ `docker inspect --format='{{.State.Health.Status}}' db-mongo` == "healthy" ]
    do 
        sleep 1
    done
}

loadData () {
    waitForUserContext
    export CONTEXT_BROKER="$1" 
    docker run --rm -v $(pwd)/import-data:/import-data \
        --network fiware_default \
        -e CONTEXT_BROKER=${CONTEXT_BROKER} \
        --entrypoint /bin/ash quay.io/curl/curl:${CURL_VERSION} /import-data
    echo ""
}

stoppingContainers () {
    CONTAINERS=$(docker ps --filter "label=org.fiware=fiware-health-poc" -aq)
    if [[ -n $CONTAINERS ]]; then 
        echo "Stopping containers"
        docker rm -f $CONTAINERS || true
    fi
    VOLUMES=$(docker volume ls -qf dangling=true) 
    if [[ -n $VOLUMES ]]; then 
        echo "Removing old volumes"
        docker volume rm $VOLUMES || true
    fi
    NETWORKS=$(docker network ls  --filter "label=org.fiware=fiware-health-poc" -q) 
    if [[ -n $NETWORKS ]]; then 
        echo "Removing fiware_fiware-health-poc networks"
        docker network rm $NETWORKS || true
    fi
}

startContainers () {
    export $(cat .env .mysql.env | grep "#" -v)
    stoppingContainers
    waitForCoreContext
    echo -e "Starting containers:  \033[1;34mOrion\033[0m, \033[1;36mIoT-Agent\033[0m, \033[1mCygnus\033[0m, a linked data \033[1mContext\033[0m, a \033[1mGrafana\033[0m metrics dashboard, \033[1mCrateDB\033[0m and \033[1mMongoDB\033[0m databases and a \033[1mRedis\033[0m cache."
    echo -e "- \033[1;34mOrion\033[0m is the context broker"
    echo -e "- Data models \033[1m@context\033[0m (Smart Health) is supplied externally"
    echo ""
    ${dockerCmd} -f health-poc.yml -p fiware up ${build} -d --renew-anon-volumes
    displayServices "orion|fiware"
    waitForMongo
    waitForOrion
    #loadData orion:1026
    echo -e "\033[1;34m${command}\033[0m is now running and exposed on localhost:${EXPOSED_PORT}"
}


displayServices () {
    echo ""
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" --filter name="$1"
    echo ""
}

command="$1"
case "${command}" in
    "help")
        echo "usage: services ${USAGE_HELP}"
        ;;
     "build")
        build="--build"
        echo "Building images on start"
        startContainers
        ;;
     "start")
        startContainers
        ;;
    "stop")
        export $(cat .env .mysql.env | grep "#" -v)
        echo "Stopping containers"
        stoppingContainers
        ;;
     "create")
        export $(cat .env .mysql.env | grep "#" -v)
        echo "Pulling Docker images"
        docker pull -q quay.io/curl/curl:${CURL_VERSION}
        ${dockerCmd} -f health-poc.yml pull
        ;;
    *)
        echo "Command not Found."
        echo "usage: services ${USAGE_HELP}"
        exit 127;
        ;;
esac
