# WARNING: Base image reference should not be set manually.
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
FROM gcr.io/forgerock-io/ds:7.0.0-32d3e305277c101ff7349e117b5b527614e1bd69
# WARNING: DS_DOCKER_TAG label should not be set manually
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
LABEL com.forgerock.ds.tag=7.0.0-32d3e305277c101ff7349e117b5b527614e1bd69
COPY schema/ /opt/opendj/db/schema/
