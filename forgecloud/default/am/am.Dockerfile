# WARNING: Base image reference should not be set manually.
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
FROM gcr.io/forgerock-io/am:7.0.0-cd642411a35f7d3347579050531ab07259f338f1
# WARNING: AM_DOCKER_TAG label should not be set manually
# To "upgrade" to a later release of the Identity Stack, use the script: /scripts/upgrade_identity_stack.sh
LABEL com.forgerock.am.tag=7.0.0-cd642411a35f7d3347579050531ab07259f338f1

ENV LOGBACK=https://repo.maven.apache.org/maven2/ch/qos/logback

ADD --chown=forgerock:root \
  $LOGBACK/contrib/logback-json-core/0.1.5/logback-json-core-0.1.5.jar \
  $LOGBACK/contrib/logback-json-classic/0.1.5/logback-json-classic-0.1.5.jar \
  $LOGBACK/contrib/logback-jackson/0.1.5/logback-jackson-0.1.5.jar \
  /usr/local/tomcat/webapps/am/WEB-INF/lib/
COPY logback.xml /usr/local/tomcat/webapps/am/WEB-INF/classes
