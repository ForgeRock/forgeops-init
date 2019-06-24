#!/bin/bash
set -e

# check for required environment variables, we check if the variable is unset, it may be empty
REQUIRED_VARIABLES="OPENAM_CORS_ACCEPTED_ORIGINS"
for VARIABLE in $REQUIRED_VARIABLES ; do
    if [ -z ${!VARIABLE+test} ]; then
        echo "ERROR: Missing required environment variable $VARIABLE"
        exit 1
    fi
done

echo "--> Configuring web.xml..."
envsubst < ${FORGEROCK_HOME}/customize/web.xml.template > ${CATALINA_HOME}/webapps/openam/WEB-INF/web.xml
