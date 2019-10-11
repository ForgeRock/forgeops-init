# WARNING: Base image reference should not be set manually.
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
FROM gcr.io/forgerock-io/ds/pit1:7.0.0-37857fd088e5717cc3b8c9675d9937a183ab80e8
# WARNING: DS_DOCKER_TAG label should not be set manually
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
LABEL com.forgerock.ds.tag=7.0.0-37857fd088e5717cc3b8c9675d9937a183ab80e8
COPY schema/ /opt/opendj/db/schema/
