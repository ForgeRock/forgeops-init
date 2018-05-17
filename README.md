# forgeops-init

Holds initial configuration for the ForgeRock platform components. 
 

NOTE: You must check out the branch of this project that corresponds to the ForgeOps project branch you are using.
For example, if you are using the release/6.0.0 forgeops project, checkout the release/6.0.0 branch of
this project. 

The master of this repository tracks the master of the forgeops project.


## About This Repository

This repository contains an initial skeleton configuration for the ForgeRock 
Identity Platform on Kubernetes. The initial configuration can be used with the 
[forgeops](https://github.com/ForgeRock/forgeops) repository 
when deploying the reference DevOps examples. 

Use this repository as a starting point for your own custom configuration 
repository for the ForgeRock Identity Platform. For more information about 
creating a cutsom configuration repository, see the chapter _Creating a Custom 
Configuration Repository_ in the _ForgeRock DevOps Guide_.

Kubernetes mounts configuration files as a volume at runtime by cloning the 
configuration repository in an init container and making the configuration 
available to the component containers.
 

## Project Layout 

The layout presented here provides 2 main folders for configuration. 

The **default** folder contains standard configuration that can be used to deploy a basic installation of each product.
These configurations are referenced in the DevOps guide.  

The directory structure is:  `/default/{component}/{config}/* `

Where:
* component is one of: am, dj, ig, idm.
* config is a specific configuration for that component.

The following sets of configuration files are provided in the skeleton configuration:
       
  * `default/am/empty-import` - Empty folder with triggers default AM deployment with
    no configuration. 
  * `default/idm/sync-with-ldap-bidirectional` - Contains configuration that 
    implements bidirectional data synchronization between IDM and LDAP.
  * `default/ig/basic-sample` - Contains configuration to deploy the simplest 
    possible IG server.


The **samples** folder contains different sets of configuration that can be used for different deployment examples.  
This folder uses the same directory structure as the /default folder.

In addition, the following top-level directory is also included:

* helm/ holds yaml files that can be used to override the default configuration of a particular Helm chart.
