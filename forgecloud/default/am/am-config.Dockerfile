FROM alpine:3.7

ENV FORGEROCK_HOME /home/forgerock

RUN mkdir -p $FORGEROCK_HOME \
 && addgroup -g 11111 forgerock \
 && adduser -s /bin/bash -h "$FORGEROCK_HOME" -u 11111 -D -G forgerock forgerock

USER forgerock

COPY --chown=forgerock:daemon am-config-docker-entrypoint.sh $FORGEROCK_HOME/
COPY --chown=forgerock:daemon config $FORGEROCK_HOME/config
#COPY --chown=forgerock:daemon security $FORGEROCK_HOME/security
#COPY --chown=forgerock:daemon keystore.jceks $FORGEROCK_HOME/keystore.jceks

ENTRYPOINT ["/home/forgerock/am-config-docker-entrypoint.sh"]
