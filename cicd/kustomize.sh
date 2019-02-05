#!/usr/bin/env bash 

env

set -x 
NS=test

echo "Deploying idm"

# Set the image tag to the sha hash that we just built in the previous stage.
# K8S will do a rolling deployment
(   cd idm/overlays/test;  \
    kustomize edit set imagetag gcr.io/engineering-devops/sk-idm:"$SHORT_SHA" && \
    kustomize edit set namespace $NS  && \
    kustomize build | \
    kubectl apply -f -  )

# Rollout IG
(   cd ig/overlays/test;  \
    kustomize edit set imagetag gcr.io/engineering-devops/sk-ig:"$SHORT_SHA" && \
    kustomize edit set namespace $NS  && \
    kustomize build | \
    kubectl apply -f -  )
