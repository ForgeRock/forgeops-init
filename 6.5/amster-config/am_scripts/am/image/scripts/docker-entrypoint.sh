#!/usr/bin/env sh
set -e

run() {
    if [ -x "${FORGEROCK_HOME}/setup_customize-am.sh" ]; then
        echo "Executing AM customization script..."
        bash "${FORGEROCK_HOME}/setup_customize-am.sh"
    else
        echo "No AM customization script found, so no customizations will be performed"
    fi

    echo "Starting AM..."
    cd "${CATALINA_HOME}"
    exec "${CATALINA_HOME}/bin/catalina.sh" run
}

wait_for_stores() {
    echo "Waiting for configstore and userstore..."
    bash ${FORGEROCK_HOME}/wait-for-it.sh -t 0 ${CONFIGSTORE_SERVICE_HOST:-openam-configstore}:${CONFIGSTORE_SERVICE_PORT:-1389}
    bash ${FORGEROCK_HOME}/wait-for-it.sh -t 0 ${USERSTORE_SERVICE_HOST:-openam-userstore}:${USERSTORE_SERVICE_PORT:-1389}
}

setup() {
    echo "Executing AM setup in background..."
    bash "${FORGEROCK_HOME}/setup_install_am.sh" &
}

wait_for_stores
setup
run

