FROM alpine:3.7

ENV FORGEROCK_HOME /home/forgerock

RUN mkdir -p $FORGEROCK_HOME \
 && addgroup -g 11111 forgerock \
 && adduser -s /bin/bash -h "$FORGEROCK_HOME" -u 11111 -D -G forgerock forgerock

USER forgerock

COPY --chown=forgerock:daemon am-config-docker-entrypoint.sh $FORGEROCK_HOME/
COPY --chown=forgerock:daemon config $FORGEROCK_HOME/config
COPY --chown=forgerock:daemon security $FORGEROCK_HOME/security
COPY --chown=forgerock:daemon keystore.jceks $FORGEROCK_HOME/keystore.jceks

ENTRYPOINT ["/home/forgerock/am-config-docker-entrypoint.sh"]


# deploy this image as an init-container within the openam pod
#- env:
#  image: gcr.io/fr-saas-registry/am-config:FRAAS-1265-AM-FBC-a8c8d9d
#  imagePullPolicy: IfNotPresent
#  name: config
#  resources: {}
#  terminationMessagePath: /dev/termination-log
#  terminationMessagePolicy: File
#  volumeMounts:
#  - mountPath: /home/forgerock/openam
#    name: openam-root
