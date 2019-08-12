# WARNING: Base image reference should not be set manually.
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
FROM gcr.io/forgerock-io/idm/pit1:7.0.0-4da29dc
# WARNING: FORGEOPS_COMMIT_SHA and IDM_DOCKER_TAG labels should not be set manually
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
LABEL FORGEOPS_COMMIT_SHA=c6e38bcbb96efe64ed32ab24f167e9fa3c476719 \
    IDM_DOCKER_TAG=7.0.0-4da29dc
COPY conf /opt/openidm/conf
COPY script /opt/openidm/script
