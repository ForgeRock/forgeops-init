# Developing the Platform OAuth2 Sample

The files in this folder are designed to assist with developing the Common Repo platform configuration, which is found in the parent folder (specifically under the amster and idm subfolders).

You have two choices for running this development environment - within Minikube or within GKE. Both have advantages and disadvantages.

Minikube:
 - No cost (assuming you have the compute resources necessary on your own machine)
 - No network dependency - can work offline
 - No credentials needed for interacting with GKE or GCR
 - Faster deployment of changes

GKE:
 - Publicly available
 - Uses real HTTPS certificate instead of self-signed
 - Less environment to setup
 - Uses no resources on your own machine

Choose whichever option works best for you. Steps for setting up either are described below:

## Initial Preparation

Have the following installed locally:

- Docker https://docs.docker.com/install/
- kubectl https://kubernetes.io/docs/tasks/tools/install-kubectl/
- Helm https://github.com/helm/helm#install
- Skaffold https://github.com/GoogleContainerTools/skaffold#installation

Clone the [forgeops](https://github.com/ForgeRock/forgeops/) git repository at the same level as this forgeops-init folder. So it should be available at ../../../../forgeops (relative to this folder). This is necessary for the "helm" symbolic link to map to the helm charts published in forgeops.

## Using Minikube

Install Minikube: https://kubernetes.io/docs/tasks/tools/install-minikube/

1. Prepare your minikube VM. This is only needed the first time the VM is created; if you restart your host or your VM, you do not need to repeat this step.

    This creates the minikube VM, enables the ingress addon, adds a new namespace to your kubectl config, initializes the helm tiller, and installs the cert-manager chart:

    ```
    minikube start --insecure-registry 10.0.0.0/24 --memory 4096 && \
    minikube addons enable ingress && \
    kubectl config set-context sample-context --namespace=sample --cluster=minikube --user=minikube && \
    sleep 2 && \
    helm init --wait && \
    helm upgrade -i cert-manager --namespace kube-system stable/cert-manager
    ```

2. You will need to run these commands every time the VM starts (after first step as well as after every VM reboot).

    These commands fix a bug in minikube related to loopback networking, prepare your Docker environment to point to the minikube Docker service, and instructs kubectl to use the proper namespace for this sample.

    ```
    minikube ssh "sudo ip link set docker0 promisc on" && \
    eval $(minikube docker-env) && \
    kubectl config use-context sample-context
    ```

3. Use skaffold to build the images and deploy the helm charts:

    ```
    skaffold dev
    ```

    This will build the docker images and incorporate them into the helm templates, followed by managing the release of the charts. Any changes made to the configuration files for each docker image (found under ../amster and ../idm) will be watched by skaffold, and will result in an automatic rebuild of the associated image followed by a redeployment into the cluster.

4. You need to add the ingress IP to your local hosts file.

    ```
    grep -v sample.iam.forgeops.com /etc/hosts | sudo tee /etc/hosts && \
    echo "$(minikube ip) sample.iam.forgeops.com" | sudo tee -a /etc/hosts
    ```

5. Wait for all of the services to become ready. You will see output on you terminal from the idm and am pods.

    When idm is finished you'll see something like this:

    ```
    [sk-idm-openidm-0 openidm] OpenIDM ready
    ```

    When amster is finished, you'll see something like this:

    ```
    [amster-6b6bb59b5b-9c6n5 amster] Import completed successfully
    [amster-6b6bb59b5b-9c6n5 amster] Configuration script finished
    [amster-6b6bb59b5b-9c6n5 amster] Args are 0
    [amster-6b6bb59b5b-9c6n5 amster] Container will now pause. You can use kubectl exec to run export.sh
    [amster-6b6bb59b5b-9c6n5 amster] + pause
    [amster-6b6bb59b5b-9c6n5 amster] + echo 'Args are 0 '
    [amster-6b6bb59b5b-9c6n5 amster] + echo 'Container will now pause. You can use kubectl exec to run export.sh'
    [amster-6b6bb59b5b-9c6n5 amster] + true
    [amster-6b6bb59b5b-9c6n5 amster] + wait
    [amster-6b6bb59b5b-9c6n5 amster] + sleep 1000000
    ```

6. Create sample users in your environment:

    ```
    kubectl exec -it configstore-0 /opt/opendj/scripts/make-users.sh 10
    ```

    This will create 10 users (from user.0 through user.9) in your DS repository.

7. Import the ForgeOps CA certificate into your system's list of trusted certificate authorities.

    In Chrome you can open chrome://settings/certificates and then navigate to the "Authorities" tab. Click "Import" and choose the "forgeops/helm/frconfig/secrets/ca.crt" file. Check the box that says "Trust this certificate for identifying websites".

    In Firefox, open about:preferences#privacy and look for the "Certificates" section (near the bottom). Click "View Certificates..." and choose the "Authorities" tab. Click "Import" and choose the "forgeops/helm/frconfig/secrets/ca.crt" file. Check the box that says "Trust this CA to identify websites."

    You may also find it useful to import this CA certificate into your operating system's trust store. Consult your OS documentation for how to do so.

8. You can access the platform by opening this URL:
    To access AM:

    ```
    https://sample.iam.forgeops.com/am/console
    ```

    You can use amadmin / password to login as the am admin.

    To access IDM:
    ```
    https://sample.iam.forgeops.com/admin/
    ```

    You can use openidm-admin / openidm-admin to login as the idm admin.

    Review the [Access the running platform](../README.md#accessing-the-running-platform) section of the general project README for more details.

9. You can stop the sample any time by just hitting Ctrl^c to exit skaffold. It will automatically remove the running processes.

    You can then rerun the sample by just starting over from step 3.

    You can also remove the whole minikube environment with this command:
    ```
    minikube delete
    ```
    After doing this, you will need to start over at step 1 if you want to run it again.

## Using GKE

Install the Google Cloud SDK: https://cloud.google.com/sdk/install

1. Login to the GKE dashboard at https://console.cloud.google.com/kubernetes and choose your project from the "Select a project" dialog. If you can't find your project there, talk to your system administrator about setting one up for you to use.

2. Use `gcloud init` to prepare your kubectl environment. After you login, choose the same project that you selected in step 1.

3. Within your browser window from step 1, choose the cluster you want to work with. From there, click on the "Connect" option and copy the "Command-line access" command provided. It should look something like this:

    ```
    gcloud container clusters get-credentials eng-shared --zone us-east1-c --project engineering-devops
    ```

    Run this command in your terminal - this will setup kubectl for your use. Afterward, set your kubectl context to use your own namespace (named from your currently-logged-in name):

    ```
    kubectl config set-context my-context --cluster=`kubectl config current-context` --user=`kubectl config current-context` --namespace=`whoami| sed -e "s/\./_/"`
    kubectl config use-context my-context
    ```

4. Login to gcr.io with Docker:

    ```
    gcloud auth configure-docker
    ```

5. Use skaffold to build the images and deploy the helm charts.

    This prepares a version of the default skaffold.yaml which is designed to push into your GCR repository and use cluster certificates:
    ```
    sed -e "s/engineering-devops/$(gcloud config list --flatten=core --format='value(project)')/" \
        -e "s/push: false/push: true/" \
        -e "s/certmanager.acme: false/certmanager.acme: true/" \
        -e "s/certmanager.issuer: ca-issuer/certmanager.issuer: letsencrypt-prod/" \
        -e "s/certmanager.issuerKind: Issuer/certmanager.issuerKind: ClusterIssuer/" \
        -e "s/sk-/`whoami| sed -e "s/\./_/"`-sk-/g" \
        skaffold.yaml > my-skaffold.yaml
    ```

    This runs skaffold using that custom configuration:
    ```
    skaffold dev -f my-skaffold.yaml
    ```

    This will build the docker images and incorporate them into the helm templates, followed by managing the release of the charts. Any changes made to the configuration files for each docker image (found under ../amster, ../idm) will be watched by skaffold, and will result in an automatic rebuild of the associated image, push to GCR, and finally a redeployment into the cluster.

6. Wait for all of the services to become ready. You will see output on you terminal from the idm, amster and rs pods.

    When idm is finished you'll see something like this:

    ```
    [sk-idm-openidm-0 openidm] OpenIDM ready
    ```

    When amster is finished, you'll see something like this:

    ```
    [amster-6b6bb59b5b-9c6n5 amster] Import completed successfully
    [amster-6b6bb59b5b-9c6n5 amster] Configuration script finished
    [amster-6b6bb59b5b-9c6n5 amster] Args are 0
    [amster-6b6bb59b5b-9c6n5 amster] Container will now pause. You can use kubectl exec to run export.sh
    [amster-6b6bb59b5b-9c6n5 amster] + pause
    [amster-6b6bb59b5b-9c6n5 amster] + echo 'Args are 0 '
    [amster-6b6bb59b5b-9c6n5 amster] + echo 'Container will now pause. You can use kubectl exec to run export.sh'
    [amster-6b6bb59b5b-9c6n5 amster] + true
    [amster-6b6bb59b5b-9c6n5 amster] + wait
    [amster-6b6bb59b5b-9c6n5 amster] + sleep 1000000
    ```

7. Create sample users in your environment:

    ```
    kubectl exec -it configstore-0 /opt/opendj/scripts/make-users.sh 10
    ```

    This will create 10 users (from user.0 through user.9) in your DS repository.

8. Access the running platform.

    Find the URL to login with using this command:
    ```
    echo https://`kubectl get ing -o jsonpath="{.items[0].spec.rules[0].host}" -l chart=openam-7.0.0`/console
    ```
    Open that URL and you will be redirected to the AM login page.

    You can use amadmin / password to login as the am admin.
    You can use user.0  / password to login as a basic end-user.

    Review the [Access the running platform](../README.md#accessing-the-running-platform) section of the general project README for more details.

9. You can stop the sample any time by just hitting Ctrl^c to exit skaffold. It will automatically remove the running processes.


## Saving configuration changes

To export changes made to the running AM pod, you'll first need to find the amster pod name:

    export AMSTER_POD=`kubectl get po -o jsonpath="{.items[0].metadata.name}" -l component=amster`

    kubectl exec -it $AMSTER_POD /opt/amster/amster
      connect http://openam -k /var/run/secrets/amster/id_rsa
      export-config --path /tmp/export
      :quit

    kubectl cp $AMSTER_POD:/tmp/export ../amster/config


To export changes made to IDM:

    export IDM_POD=`kubectl get po -o jsonpath="{.items[0].metadata.name}" -l component=openidm`
    kubectl cp $IDM_POD:/opt/openidm/conf ../idm/conf

Review changes to config using git diff. Remove all untracked files with this command:

    git clean -fdx
