#!/bin/bash
set -e

SERVER_URL=${OPENAM_INSTANCE:-http://localhost:8080}
URI=${SERVER_URI:-/openam}
INSTANCE="${SERVER_URL}${URI}"

# Alive check
ALIVE_URL="${INSTANCE}/isAlive.jsp"
# Config page. This comes up if AM is not configured.
CONFIG_URL="${INSTANCE}/config/options.htm"

# Wait for AM to come up before configuring it.
# Curl times out after 2 minutes regardless of the --connect-timeout setting.
wait_for_openam() {
    echo "--> Waiting for AM server at ${ALIVE_URL} "
    
    # If we are lucky, AM will be up before the first curl command is issued.
    sleep 5
    response="000"

    while true
    do
        response=$(curl --write-out %{http_code} --silent --connect-timeout 30 --output /dev/null ${ALIVE_URL})
        if [ ! ${response} = "000" ]; then
            echo "---> AM web app running, checking configuration state"
            break
        fi
        
        echo "---> Response code ${response}. Will continue to wait"
    done

    response=$(curl --write-out %{http_code} --silent --connect-timeout 30 --output /dev/null ${CONFIG_URL})
    echo "--> Got Response code $response"
    if [ ${response} = "200" ]; then
        echo "--> AM is ready to be configured"
    else
        echo "--> It looks like AM is already configured. Exiting AM setup."
        exit 0
    fi
}

setup_am_with_amster() {
    # Execute Amster if the configuration is found.
    if [ -d  ${AMSTER_SCRIPTS} ]; then
        echo "--> Executing Amster to configure AM"
        # Need to be in the amster directory, otherwise Amster can't find its libraries.
        pushd ${AMSTER_HOME}
        for file in ${AMSTER_SCRIPTS}/*.amster
        do
            echo "---> Executing Amster script $file"
            bash ./amster ${file}
        done
        popd
    fi
    
    echo "--> Finished configuration with Amster"
}


wait_for_openam
setup_am_with_amster