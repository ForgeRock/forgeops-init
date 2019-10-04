#!/usr/bin/env bash


# temporary script for building am-config Docker image and pushing it to gcr

docker build -t gcr.io/fr-saas-registry/am-config:FRAAS-1265-AM-FBC-43c870f -f am-config.Dockerfile .

docker push gcr.io/fr-saas-registry/am-config:FRAAS-1265-AM-FBC-43c870f

# deploy this image as an init-container within the openam pod
#- env:
#  image: gcr.io/fr-saas-registry/am-config:FRAAS-1265-AM-FBC-43c870f
#  imagePullPolicy: Always
#  name: config
#  resources: {}
#  terminationMessagePath: /dev/termination-log
#  terminationMessagePolicy: File
#  volumeMounts:
#  - mountPath: /home/forgerock/openam
#    name: openam-root


docker run -it --entrypoint ash gcr.io/fr-saas-registry/am-config:FRAAS-1265-AM-FBC-43c870f