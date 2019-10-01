#!/usr/bin/env bash

###
# This script extracts the default conf and script files from the IDM Docker image

###
# Constants

SCRIPT_DIR=$(dirname $0)
GIT_REPO_ROOT=$(cd "${SCRIPT_DIR}/.."; pwd)
IDM_EXPORT_DIR=${GIT_REPO_ROOT}/forgecloud/default/idm/base
IDM_DOCKER_IMAGE=$(cat ${GIT_REPO_ROOT}/forgecloud/default/idm/Dockerfile | grep "FROM " | cut -d ' ' -f 2)

###
# Extract files from IDM image by running a temporary container

echo -n "Extracting default IDM config for ${IDM_DOCKER_IMAGE} to ${IDM_EXPORT_DIR}..."

IDM_CONTAINER=$(docker create ${IDM_DOCKER_IMAGE})
rm -rf ${IDM_EXPORT_DIR}/conf
rm -rf ${IDM_EXPORT_DIR}/script
docker cp ${IDM_CONTAINER}:/opt/openidm/conf ${IDM_EXPORT_DIR}
docker cp ${IDM_CONTAINER}:/opt/openidm/script ${IDM_EXPORT_DIR}
1>/dev/null docker rm -v ${IDM_CONTAINER} # redirecting stdout to suppress container id output

echo " done"
