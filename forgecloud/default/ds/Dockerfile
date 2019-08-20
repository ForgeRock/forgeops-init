# WARNING: Base image reference should not be set manually.
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
FROM gcr.io/forgerock-io/ds/pit1:7.0.0-dde97a1
# WARNING: DS_DOCKER_TAG label should not be set manually
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
LABEL com.forgerock.ds.tag=7.0.0-dde97a1
COPY schema/ /opt/opendj/db/schema/
