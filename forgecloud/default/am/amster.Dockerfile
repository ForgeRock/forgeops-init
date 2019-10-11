# WARNING: Base image reference should not be set manually.
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
FROM gcr.io/forgerock-io/amster/pit1:7.0.0-d502679953325f8cc0b2b00dbe45911ff86a30d0
# WARNING: AMSTER_DOCKER_TAG label should not be set manually
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
LABEL com.forgerock.amster.tag=7.0.0-d502679953325f8cc0b2b00dbe45911ff86a30d0
COPY global /opt/amster/config/global
COPY realms /opt/amster/config/realms
COPY import-config.sh /opt/amster/
