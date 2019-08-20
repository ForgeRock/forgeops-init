# WARNING: Base image reference should not be set manually.
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
FROM gcr.io/forgerock-io/idm/pit1:7.0.0-576f4b6d46617db6dfe00d00a0f28dc9db5b6123
# WARNING: IDM_DOCKER_TAG label should not be set manually
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
LABEL com.forgerock.idm.tag=7.0.0-576f4b6d46617db6dfe00d00a0f28dc9db5b6123
COPY conf /opt/openidm/conf
COPY script /opt/openidm/script
