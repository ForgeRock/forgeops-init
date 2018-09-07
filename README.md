# forgeops-init

Holds initial configuration for the ForgeRock platform components. 
 

NOTE: You must check out the branch of this project that corresponds to the ForgeOps project branch you are using.
For example, if you are using the release/6.0.0 forgeops project, checkout the release/6.0.0 branch of
this project. 

The master of this repository tracks the master of the forgeops project.


## About This Repository

This repository contains an sample configuration for the ForgeRock 
Identity Platform on Kubernetes. The configuration can be used with the 
[forgeops](https://github.com/ForgeRock/forgeops) repository 
when deploying the reference DevOps examples. 

Use this repository as a starting point for your own custom configuration 
repository for the ForgeRock Identity Platform. For more information about 
creating a custom configuration repository, see the chapter _Creating a Custom 
Configuration Repository_ in the _ForgeRock DevOps Guide_.

Kubernetes mounts configuration files as a volume at runtime by cloning the 
configuration repository in an init container and making the configuration 
available to the component containers.
 

## Project Layout 

The directory structure is `/{version}/{config}/{component}/*`

**version** refers to the product release version. Currently 6.0 or 6.5.  
**config** is a name given to that particular sample of configuration.  
**component** refers to product name, one of am/ds/ig/idm.

Basic product configuration, as referenced in the get started guides, can be found under `/{version}/default/{component}/*`:
       
  * `/{version}/default/am/empty-import` - Empty folder which triggers default AM deployment with
    no configuration. 
  * `/{version}/default/idm/sync-with-ldap-bidirectional` - Contains configuration that 
    implements bidirectional data synchronization between IDM and LDAP.
  * `/{version}/default/ig/basic-sample` - Contains configuration to deploy the simplest 
    possible IG server.

