# WARNING: Base image reference should not be set manually.
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
FROM gcr.io/forgerock-io/ds:7.0.0-1fb511561463754f900ae7f19d42cc6e3ec845ec
# WARNING: DS_DOCKER_TAG label should not be set manually
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
LABEL com.forgerock.ds.tag=7.0.0-1fb511561463754f900ae7f19d42cc6e3ec845ec
COPY schema/ /opt/opendj/db/schema/
