# WARNING: Base image reference should not be set manually.
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
FROM gcr.io/forgerock-io/amster:7.0.0-cd642411a35f7d3347579050531ab07259f338f1
# WARNING: AMSTER_DOCKER_TAG label should not be set manually
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
LABEL com.forgerock.amster.tag=7.0.0-cd642411a35f7d3347579050531ab07259f338f1
COPY global /opt/amster/config/global
COPY realms /opt/amster/config/realms
COPY import-config.sh /opt/amster/
