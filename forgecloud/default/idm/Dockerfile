# WARNING: Base image reference should not be set manually.
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
FROM gcr.io/forgerock-io/idm:7.0.0-b5e57894d2ff9f65faab021ac4b9742eb6a211f9
# WARNING: IDM_DOCKER_TAG label should not be set manually
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
LABEL com.forgerock.idm.tag=7.0.0-b5e57894d2ff9f65faab021ac4b9742eb6a211f9
COPY conf /opt/openidm/conf
COPY script /opt/openidm/script
