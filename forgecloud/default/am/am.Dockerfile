# WARNING: Base image reference should not be set manually.
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
FROM gcr.io/forgerock-io/am/pit1:7.0.0-481bd1a8e5
# WARNING: FORGEOPS_COMMIT_SHA and AM_DOCKER_TAG labels should not be set manually
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
LABEL com.forgerock.forgeops.hash=c6e38bcbb96efe64ed32ab24f167e9fa3c476719 \
    com.forgerock.am.tag=7.0.0-481bd1a8e5
