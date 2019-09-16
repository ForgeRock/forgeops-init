# WARNING: Base image reference should not be set manually.
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
FROM gcr.io/forgerock-io/idm:7.0.0-2cdee7ccd81a2c6f09ab4363843cd1bf4d2ab254
# WARNING: IDM_DOCKER_TAG label should not be set manually
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
LABEL com.forgerock.idm.tag=7.0.0-2cdee7ccd81a2c6f09ab4363843cd1bf4d2ab254
COPY conf /opt/openidm/conf
COPY script /opt/openidm/script
