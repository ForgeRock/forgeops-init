# WARNING: Base image reference should not be set manually.
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
FROM gcr.io/forgerock-io/idm/pit1:7.0.0-87895f2da9140325f45c833cb22175034206ef43
# WARNING: IDM_DOCKER_TAG label should not be set manually
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
LABEL com.forgerock.idm.tag=7.0.0-87895f2da9140325f45c833cb22175034206ef43
COPY conf /opt/openidm/conf
COPY script /opt/openidm/script
