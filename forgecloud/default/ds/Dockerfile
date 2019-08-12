# WARNING: Base image reference should not be set manually.
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
FROM gcr.io/forgerock-io/ds/pit1:7.0.0-179536e
# WARNING: FORGEOPS_COMMIT_SHA and DS_DOCKER_TAG labels should not be set manually
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
LABEL FORGEOPS_COMMIT_SHA=c6e38bcbb96efe64ed32ab24f167e9fa3c476719 \
    DS_DOCKER_TAG=7.0.0-179536e
COPY schema/ /opt/opendj/db/schema/
