# WARNING: Base image reference should not be set manually.
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
FROM gcr.io/forgerock-io/amster:7.0.0-f0e19e1456c8aa08ef6b12907765ad3ace6c05bc
# WARNING: AMSTER_DOCKER_TAG label should not be set manually
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
LABEL com.forgerock.amster.tag=7.0.0-f0e19e1456c8aa08ef6b12907765ad3ace6c05bc
COPY global /opt/amster/config/global
COPY realms /opt/amster/config/realms
COPY import-config.sh /opt/amster/
