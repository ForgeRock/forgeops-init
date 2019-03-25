# Skaffold / Kustomize POC

This is a demonstration / POC. Use at your own risk!

## Motivation

* Run in "tiller-less" mode for simplicity and to avoid RBAC issues.
* Avoid the proliferation of helm value.yaml overrides.
* Avoid `helm upgrade`, which is known to be problematic.
* Manage the changes in upstream helm charts.
* Support fast iteration in "dev" mode
* Support CD in "test/qa" mode

## Pre-reqs / tools

* [kustomize](https://github.com/kubernetes-sigs/kustomize). This will soon be integrated into kubectl.
* [skaffold](https://skaffold-latest.firebaseapp.com/)
* [ship](https://www.replicated.com/ship/)

## Setup

The Kustomize templates are created by ship. I highly suggest reading the ship documentation before proceeding.

First time only setup (this has already been completed in this folder - but do try this out yourself in a test environment).

```
mkdir ig
cd ig
ship init https://github.com/ForgeRock/forgeops/tree/master/helm/openig
```

Customize the values.yaml in the ship UI and save. This creates a kustomize base + overlays.

You can run these samples using

```
kustomize build ig/overlays/ship | kubectl apply -f -
```

Or just run `kustomize build ig/overlays/ship` if you want to see the kustomize output.

Subsequent runs

```
ship update --headed
```
This pulls in any upstream changes from the chart, and lets you adjust any values. The basic idea is that ship
helps you manage the process of merging in upstream changes as they occur. `ship update` can be run as an automated CD process.

This is the stage where you want to customize the app for your specific environment. Your ingress for example.  Don't be
afraid to rerun `ship update --headed` as often as needed to adjust your settings.

If you have a few different profiles that you want to switch between, make a copy of the overlays/ship folder (say overlays/my-config) and edit the kustomizations as required. You can then deploy with `kustomize build ig/overlays/my-config`.

## Development

For faster iteration, the skafflold files have been broken up into separate skaffold.yaml files. This lets you iterate on just the component you are intersted in.

The `skaffold-db.yaml` runs the peristence services (in theory these dont change often). In a new shell window:

```
skaffold run -p skaffold-db.yaml
```

To run IG or IDM, open a new shell window:

```
cd ig
skaffold dev
```

Skaffold will build a new docker image with the configuration json "baked" into the image (see the docker/Dockerfile). We don't use init
containers in this workflow (in fact - they will likely be removed in 7.x)

If you are running against a GKE cluster, skaffold will push your image up to gcr.io. It is quite fast - making development on a "real" cluster entirely feasible.  If you are running locally, skaffold will `docker build` the image directly to the cache, and will not attempt to ` docker push` it.

In `dev` mode, the docker containers are tagged with the sha256 image hash. Skaffold runs the deployment through kustomize, and fixes up the tags before they are sent to the cluster.

Try to edit an IG configuration file (say docker/config/routes/99-default.json).  You should see the docker image being rebuilt with a new sha256 tag, and the deployment updated on the cluster.  

Because we are using deployments, you can experiment with rolling upgrades in Kubernetes. For example, try to roll back IG to the last docker image. Something like:

```
kubectl rollout history deployments/openig-openig --revision=4
kubectl rollout undo  deployment/openig-openig --to-revision=2
```

## CD Process

When the deployer is happy with the resulting configuration, the changes are committed with git and pushed to a branch on github.

For the demo, we are using a [Google Cloud Build](https://cloud.google.com/cloud-build/) hook that triggers on a commit to Github (set this up for your project [here](https://console.cloud.google.com/cloud-build/builds).

On a commit, the trigger fires and runs the cloudbuild task specified in `cloudbuild.yaml`.

The deployment flow is  similiar to the the 'dev' flow, with some exceptions:

* The images are tagged with a git sha, instead of a sha256 image hash. This provides a repeatable process to build the image (it's all in git)
* `skaffold deploy` is used instead of `skaffold dev`. This is a one shot "deploy and exit" flow.
* We use kustomize overlays to change the attributes that are unique to the `test` deployment (namespace, ingress, etc.)

Applications are deployed using rolling updates. This does not work yet for AM - stay tuned! Again, you can use `kubectl` to perform rollbacks.

## Notes

During development you will create a lot of images. Skaffold does not yet garbage collect images. There is an issue filed.  For local docker, you can try:

```docker system prune```

For GKE and other repositories a garbage collection task is required.

## Future Directions

* Run in-namespace QA suite. Promote to 'production' namespace on success.
* Label deployments with versions to support canary releases (using istio, for example)
* Helm 3. Solves the tiller issues.
