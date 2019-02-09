# forgeops-init

Holds initial configuration for the ForgeRock platform components. 

## About This Repository

This repository contains sample configurations for the ForgeRock 
Identity Platform on Kubernetes. The configuration can be used with the 
[forgeops](https://github.com/ForgeRock/forgeops) repository 
when deploying the reference DevOps examples. 

Use this repository as a starting point for your own custom configuration 
repository for the ForgeRock Identity Platform. For more information about 
creating a custom configuration repository, see the section _Setting up Your  
Configuration Repository_ in the _ForgeRock DevOps Developers Guide_.

Kubernetes mounts configuration files as a volume at runtime by cloning the 
configuration repository in an init container and making the configuration 
available to the component containers.
 

## Project Layout 

The directory structure is `/{version}/{config}/{component}/*`

**version** refers to the product release version. Currently 6.0 or 6.5.  
**config** is a name given to that particular sample of configuration. This can
have multiple directory levels.  
**component** refers to product name, one of am/ds/ig/idm.

Basic product configuration, as referenced in the _DevOps Quick Start Guide_, can be found under `/{version}/default/{component}/*`:
       
  * `/{version}/default/am/empty-import` - Empty folder which triggers default AM deployment with
    no configuration. 
  * `/{version}/default/idm/sync-with-ldap-bidirectional` - Contains configuration that 
    implements bidirectional data synchronization between IDM and LDAP.
  * `/{version}/default/ig/basic-sample` - Contains configuration to deploy the simplest 
    possible IG server.
    
## Contents

The below table summarizes the content of each configuration directory.  Each config directory contains a further readme with specific details about the individual product configurations.

### 6.5 configurations   

Directory                   | Contents
----------------------------|-------------------------------------------
|---------------------------|**BENCHMARKS**||
|/6.5/**benchmarks**        | Benchmark configurations.
|/6.5/benchmarks/**gatling-simulation-files**  | Gatling simulation files for running benchmarks.
|/6.5/benchmarks/**ig-benchmark-reverse-nginx**  | IG reverse proxy handler in front of static web page(nginx).
|---------------------------| **CLOUD DEPLOYMENT MODEL**
|/6.5/**cdm**               | Cloud Deployment Model (Common use ForgeRock Identity Platform deployment).
|/6.5/cdm/**m-cluster**     | Medium size cluster CDM example configs for AM and IDM.  
|/6.5/cdm/m-cluster/**am**  | AM config for medium cluster.
|/6.5/cdm/m-cluster/**idm** | IDM config for medium cluster.
|---------------------------|**DEFAULT CONFIGURATIONS**||
|/6.5/**default**           | Default out of the box configurations to get started using our products.
|/6.5/default/**am**        | Empty config which triggers default installation of AM.
|/6.5/default/**idm**       | Bi-directional LDAP sync with internal repository.
|/6.5/default/**ig**        | Default handler returning IG home page.
|---------------------------|**SMOKE TESTS**||
|/6.5/**smoke-tests**       | Smoke test configurations.
|/6.5/smoke-tests/**am**    | AM smoke tests.
|/6.5/smoke-tests/**idm.postgres**  | IDM smoke test with postgres repo.
|/6.5/smoke-tests/**idm**   | IDM smoke test.
|/6.5/smoke-tests/**ig**    | IG smoke test.

### 6.0 configurations   

Directory                   | Contents      
|---------------------------|-------------------------------------------
|---------------------------| **CLOUD DEPLOYMENT MODEL**
|/6.0/**cdm**               | Cloud Deployment Model (Common use ForgeRock Identity Platform deployment).
|/6.0/cdm/**m-cluster**     | Medium size cluster CDM example configs for AM and IDM.  
|/6.0/cdm/m-cluster/**am**  | AM config for medium cluster.
|/6.0/cdm/m-cluster/**idm** | IDM config for medium cluster.
|---------------------------|**DEFAULT CONFIGURATIONS**||
|/6.0/**default**           | Default out of the box configurations to get started using our products. 
|/6.0/default/**am**        | Empty config which triggers default installation of AM. 
|/6.0/default/**idm**       | Bi-directional LDAP sync with internal repository.
|/6.0/default/**ig**        | Default handler returning IG home page
|---------------------------| **IDENTITY PLATFORM EXAMPLES**
|/6.0/**identity-platform-examples** | Example ForgeRock Identity Platform configurations.
|/6.0/identity-platform-examples/**am-ds**  | Custom AM server with multiple DS stores.  
|/6.0/identity-platform-examples/**idm-am-integration-shared-ds** | IDM with AM authentication sharing the same DS userstore.
 


 ### 7.0 configurations   

 The 7.0 directory currently contains a copy of the idm 6.5 configuration, with the UI contexts updated to align with the new istio ingress (/idm, /admin, /openidm). It is otherwise identical to the 6.5 configuration.

#### CI/CD POC

cicd/ contains a work in progress demonstration (7.0)