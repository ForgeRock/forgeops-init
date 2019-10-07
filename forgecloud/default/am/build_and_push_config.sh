#!/usr/bin/env bash


# temporary script for building am-config Docker image and pushing it to gcr

docker build -t gcr.io/fr-saas-registry/am-config:FRAAS-1265-AM-FBC-latest -f am-config.Dockerfile .

docker push gcr.io/fr-saas-registry/am-config:FRAAS-1265-AM-FBC-latest

# deploy this image as an init-container within the openam pod
#      - image: gcr.io/fr-saas-registry/am-config:FRAAS-1265-AM-FBC-latest
#        imagePullPolicy: Always
#        name: config
#        resources: {}
#        terminationMessagePath: /dev/termination-log
#        terminationMessagePolicy: File
#        volumeMounts:
#        - mountPath: /home/forgerock/openam
#          name: openam-root


#      - args:
#        - bootstrap
#        env:
#        - name: BASE_DN
#          value: ou=am-config
#        - name: CONFIGURATION_LDAP
#          value: userstore-0.userstore:1389
#        image: gcr.io/fr-saas-registry/forgeops-util:FRAAS-1265-AM-FBC-28ba654
#        imagePullPolicy: Always
#        name: bootstrap
#        resources: {}
#        terminationMessagePath: /dev/termination-log
#        terminationMessagePolicy: File
#        volumeMounts:
#        - mountPath: /home/forgerock/openam
#          name: openam-root
#        - mountPath: /var/run/secrets/openam
#          name: openam-keys
#        - mountPath: /var/run/openam
#          name: openam-boot
#        - mountPath: /var/run/secrets/configstore
#          name: configstore-secret


#docker run -it --entrypoint ash gcr.io/fr-saas-registry/am-config:FRAAS-1265-AM-FBC-dadf2cc