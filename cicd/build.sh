#!/usr/bin/env bash

set -x

# Set our namespace to deploy. TODO: We could pick this up from the branch. 
NS=test
echo "Cloudbuild environment:"

env

echo "Running skaffold to build docker containers"

skaffold build

echo "Deploying to $NS namespace"

kubectl version 

# Create the namespace in case it does not exist
kubectl create ns $NS 
kubectl config set-context $(kubectl config current-context) --namespace="$NS"

echo "Deploy persistence"

skaffold deploy -f skaffold-db.yaml 
