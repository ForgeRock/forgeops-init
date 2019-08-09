# WARNING: Base image reference should not be set manually.
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
FROM gcr.io/forgerock-io/amster/pit1:7.0.0-481bd1a8e5
COPY global /opt/amster/config/global
COPY realms /opt/amster/config/realms
