FROM alpine:3.7

ENV FORGEROCK_HOME /home/forgerock

RUN mkdir -p $FORGEROCK_HOME \
 && addgroup -g 11111 forgerock \
 && adduser -s /bin/bash -h "$FORGEROCK_HOME" -u 11111 -D -G forgerock forgerock

USER forgerock

RUN mkdir -p $FORGEROCK_HOME/fbc

COPY --chown=forgerock:daemon am-config-docker-entrypoint.sh $FORGEROCK_HOME/
COPY --chown=forgerock:daemon openam/config $FORGEROCK_HOME/fbc/openam/config
COPY --chown=forgerock:daemon openam/authorized_keys $FORGEROCK_HOME/fbc/openam/authorized_keys
COPY --chown=forgerock:daemon openam/security $FORGEROCK_HOME/fbc/openam/security

ENTRYPOINT ["/home/forgerock/am-config-docker-entrypoint.sh"]
