# stack-config

##Warning

**This code is not supported by ForgeRock and it is your responsibility to verify that the software is suitable and safe for use.**

##About

This repository contains an initial skeleton configuration for the ForgeRock stack deployment on Kubernetes.
This is used in conjunction with the https://stash.forgerock.org/projects/DOCKER/repos/fretes project. 
The files in this directory are (mostly) auto-generated.

You can fork and clone this project to use as starting point. 

These configuration files will get mounted as a volume by Kubernetes when the products are being configured. The volume type 
can be a gitRepo clone, or any other mechanism you choose. For example, on minikube you can map a local folder 
on your Mac to a hostPath volume in Kubernetes. This allows you to do interactive development and import / export the
configuration as you develop. When you are happy with the configuration, you can version those changes and push
them to your own git repo. See the fretes project above for more information.


## OpenAM

The OpenAM configuration is in amster/. It has a minimal setup for a root realm and test realm. There is a sample
OIDC client configured for OpenIDM.

The shell script ./fqdn.sh is an example of how to search/replace the FQDN of OpenAM in the configuration to match
your requirements (for example, changing .example.com to .acme.com).

The ./rm-site-config.sh shell script removes a few files that are not needed as they are generated on install. 
This makes it easier to fix up the FQDN. 

## OpenIDM

The OpenIDM configuration is in openidm/.  It is essentially "sample2b" that has been modified to use the OpenAM
userdatastore-0 as the managed LDAP directory. 

## OpenIG

There is a skeleton OpenIG configuration in ./openig



