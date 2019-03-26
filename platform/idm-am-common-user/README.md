# Platform Common Repo Sample

This is a sample project demonstrates using AM and IDM with DS as their common repo.

The easiest way to start this configuration is using the instructions found under [development](./development). If you want to run this configuration in a more production-oriented way, you deploy each of these helm charts from forgeops:

 - frconfig
 - amster
 - openidm
 - openam
 - ds

You will need to adjust the config path values for amster, openig and openidm to point to the appropriate subfolders under this forgeops-init structure.

 - "amster" contains the amster configuration
 - "idm" contains the openidm configuration

## Accessing the running platform

Find the URL to login with using this command:
```
echo https://`kubectl get ing -o jsonpath="{.items[0].spec.rules[0].host}" -l chart=openam-6.5.0`/console
```
Open that URL and you will be redirected to the AM login page.

You can use amadmin / password to login as the AM admin.

You can use user.0  / password to login as a basic end-user.
