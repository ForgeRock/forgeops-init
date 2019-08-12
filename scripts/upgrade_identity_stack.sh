#!/usr/bin/env bash

###
# This script updates the FROM Docker image references of AM, Amster, DS and IDM.
# This automates the process of "upgrading" our Docker images to a later "release" of forgeops.

###
# Constants

# Absolute path to root of this Git repo
GIT_REPO_ROOT="${BASH_SOURCE%/*}/.."
GIT_REPO_ROOT=$(cd "${GIT_REPO_ROOT}"; pwd)
# forgeops branch to use
#  Commits to forgeops master should only be permitted when PIT 1 tests pass
#  Commits to forgeops stable should only be permitted when PIT 2 tests pass
#  Currently tracking master as PIT 2 tests are still being finalised
FORGEOPS_BRANCH=master

function print {
  echo -n -e "\e[33m${1}\e[0m"
}

function println {
  echo -e "\e[33m${1}\e[0m"
}

###
# Clone HEAD commit to forgeops branch (as set by ${FORGEOPS_BRANCH})

println "Cloning HEAD commit to forgeops ${FORGEOPS_BRANCH}..."

rm -rf /tmp/forgeops
cd /tmp
git clone --single-branch --branch ${FORGEOPS_BRANCH} --depth=1 https://stash.forgerock.org/scm/cloud/forgeops.git
cd /tmp/forgeops

###
# Establish Docker image references to use for AM, Amster, DS and IDM

println
print "Reading references from forgeops... "

cat > /tmp/.forgeopsRefs << EOF
FORGEOPS_BRANCH=${FORGEOPS_BRANCH}
FORGEOPS_COMMIT_SHA=$(git log -n 1 --format=oneline | cut -d " " -f 1)
AM_DOCKER_REPO=$(yq r helm/openam/values.yaml image.repository)
AM_DOCKER_TAG=$(yq r helm/openam/values.yaml image.tag)
AMSTER_DOCKER_REPO=$(yq r helm/amster/values.yaml image.repository)
AMSTER_DOCKER_TAG=$(yq r helm/amster/values.yaml image.tag)
DS_DOCKER_REPO=$(yq r helm/ds/values.yaml image.repository)
DS_DOCKER_TAG=$(yq r helm/ds/values.yaml image.tag)
IDM_DOCKER_REPO=$(yq r helm/openidm/values.yaml image.repository)
IDM_DOCKER_TAG=$(yq r helm/openidm/values.yaml image.tag)
EOF

println "done"

# print references to console
cat /tmp/.forgeopsRefs

# Write record of all references to file which will be checked into Git
# This reference file will be consumed by the script saas/devtools/upgrade_identity_stack.sh

println
print "Writing record of the references used by this script to the file .forgeopsRefs... "

cat > ${GIT_REPO_ROOT}/.forgeopsRefs << EOF
###
# Generated at $(date -u +"%Y-%m-%dT%H:%M:%SZ") by forgeops-init/scripts/upgrade_identity_stack.sh
#
# This file records the forgeops branch and commit from which all the Identity Stack Docker
# image references were taken.  It also records what these references were.
# This reference is consumed by the script saas/devtools/upgrade_identity_stack.sh

$(cat /tmp/.forgeopsRefs)
EOF

println "done"

# load the variables written to the reference file
. ${GIT_REPO_ROOT}/.forgeopsRefs

###
# Update base image used by all Identity Stack Docker images

println
print "Writing updates to Identity Stack Docker files... "

# Updates base image reference to "upgrade" to a later release.
# Also adds labels to Docker image so that it's easy to trace the lineage of any Docker image created from this file.
function update_dockerfile() {
    PRODUCT=$1
    DOCKER_FILE=$2
    DOCKER_REPO=$3
    DOCKER_TAG=$4

    FROM_LINE=$(grep -nr "FROM " ${DOCKER_FILE} | cut -d : -f 2)
    LENGTH=$(wc -l < ${DOCKER_FILE})

    TEMP_DOCKER_FILE=/tmp/tmp.Dockerfile
    cp ${DOCKER_FILE} ${TEMP_DOCKER_FILE}
    # NB. using ; rather than / as the sed delimiter character as the Docker image repo name contains /
    sed -i.bak -E "s;FROM .*;FROM ${DOCKER_REPO}:${DOCKER_TAG};" ${TEMP_DOCKER_FILE}
    # NB. ending the first label line with backslash so that we define both labels in a single Docker layer
    #     we need to double-escape the backslash though (once for bash, and once for sed) so end up with \\\\
    sed -i.bak -E "s/LABEL FORGEOPS_COMMIT_SHA=.*/LABEL FORGEOPS_COMMIT_SHA=${FORGEOPS_COMMIT_SHA} \\\\/" ${TEMP_DOCKER_FILE}
    sed -i.bak -E "s/    ${PRODUCT}_DOCKER_TAG=.*/    ${PRODUCT}_DOCKER_TAG=.${DOCKER_TAG}/" ${TEMP_DOCKER_FILE}
    mv /tmp/tmp.Dockerfile ${DOCKER_FILE}
}

update_dockerfile "AM" ${GIT_REPO_ROOT}/forgecloud/default/am/am.Dockerfile ${AM_DOCKER_REPO} ${AM_DOCKER_TAG}
update_dockerfile "AMSTER" ${GIT_REPO_ROOT}/forgecloud/default/am/amster.Dockerfile ${AMSTER_DOCKER_REPO} ${AMSTER_DOCKER_TAG}
update_dockerfile "DS" ${GIT_REPO_ROOT}/forgecloud/default/ds/Dockerfile ${DS_DOCKER_REPO} ${DS_DOCKER_TAG}
update_dockerfile "IDM" ${GIT_REPO_ROOT}/forgecloud/default/idm/Dockerfile ${IDM_DOCKER_REPO} ${IDM_DOCKER_TAG}

println "done"

cat << EOF

Please commit these changes to a branch and push to GitHub.

Once all updated Identity Stack Docker images have been built by CodeFresh, you
can run saas/devtools/upgrade_identity_stack.sh as the next step in getting these
changes deployed to a customer environment.

EOF
