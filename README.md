# forgeops-init

If you are using this repository with the 5.0.0 release as documented in the 
DevOps guide, check out the `release/5.0.0` branch. Otherwise, check out the 
`master` branch.


## About This Repository

This repository contains an initial skeleton configuration for the ForgeRock 
Identity Platform on Kubernetes. The initial configuration can be used with the 
[forgeops](https://stash.forgerock.org/projects/CLOUD/repos/forgeops) repository 
when deploying the reference DevOps examples. 

Use this repository as a starting point for your own custom configuration 
repository for the ForgeRock Identity Platform. For more information about 
creating a cutsom configuration repository, see the chapter _Creating a Custom 
Configuration Repository_ in the _ForgeRock DevOps Guide_.

Kubernetes mounts configuration files as a volume at runtime by cloning the 
configuration repository in an init container and making the configuration 
available to the component containers.
 

## Project Layout 

The layout presented here is purely an example of how you might organize your configuration. The basic
idea is that configurations are organized by environments (dev, qa, production, prod_east, prod_west, etc.)

The directory structure is:  `/{environment}/{component}/{project}/* `

Where:
* environment is one of default, dev,qa, prod, etc. Environment names may be mapped to Kubernetes namespaces. It
is recommended they are short, lower case, and avoid any non alphanumeric characters. The "default" environment
is a common Kubernetes namespace used on Minikube. This is the recommended folder for out of box deployment.
* component is one of: am, dj, ig, idm
* project - is a specific configuration for that component. For example, "my-test-config", "current", "canary".
These names may be also be mapped as part of the environment, so it is best is to avoid special characters
other than '-'. 


Nested underneath the project folder are the configuration files for the component. For example, json files exported by OpenIDM or 
by amster. 

In addition, the following top-level directories are suggested:

* bin/  holds utility scripts that are useful for managing configuration files. In the future this may include scripts 
 to auto-migrate configuration from one environment to another.
* common/{component}  Holds any configuration files which are 100% common to all environments. 


## Migration

Migration from one environment to another (for example from dev to QA to prod) is done manually by
copying files from one environment to another and adjusting those files as required (for example,
replacing dev server names with QA).  You may wish to use additional tools or scripts to help automate this
process.


A sample workflow that you might implement:

* A feature is developed in the default or dev environment, and exported/saved to the {project} folder.
* The feature and/or the entire configuration is copied to the next environment. This can be scripted and 
 triggered by a git commit hook. The
 scripts can copy files and perform environment specific search and replace. 
* If a feature is consistent in all environments, it can be exported to common/{component}. You would
merge the features in common/ into the target environment.
* The resulting merged configuration is committed to git. Automated CI/CD tools may run checks on this
commit to validate the configuration is functional. 


## Repository Organization 

This skeleton repository contains the following top-level directories:
 
  * `bin/` - Holds utility scripts that are useful for managing configuration 
    files. For example, you could use the `bin` directory for scripts that 
    automatically migrate configuration from one environment to another.
  * `common/{component}` - Holds configuration files that are common to all 
    environments. 
  * `{environment}/{component}/{project}` - Holds one or more sets of 
    configuration files for a component using the following path naming 
    conventions: 
    * {environment} - A deployment environment, for example, default, dev, qa, 
      production, prod_us_east, prod_eur, etc. The skeleton repository comes 
      populated with the `default` environment, which includes starting 
      configurations. You are responsible for creating environment directories 
      other than `default` that are pertinent to your organization. Because you  
      might want to map environment names to Kubernetes namespaces, it is 
      recommended that you create environment names consisting only of lowercase 
      characters, numbers, and hyphens. 
    * {component} - A component of the ForgeRock Identity Platform. Specify am, 
      idm, or ig. (Note that other subdirectories under `default` contain a 
      variety of supporting files used for various purposes.)
    * {project} - An identifier for a set of configuration files.
       
The following sets of configuration files are provided in the skeleton 
configuration:
       
  * `default/am/empty-import` - Contains configuration that populates AM with
    no configuration. 
  * `default/idm/sync-with-ldap-bidirectional` - Contains configuration that 
    implements bidirectional data synchronization between IDM and LDAP.
  * `default/ig/basic-sample` - Contains configuration to deply the simplest 
    possible IG server.
    
After creating your own configuration repository, you might have custom sets of 
configuration files similar to the following:

  * `qa/am/oauth2` - Deploy AM as an OAuth 2.0 server in the QA environment.
  * `prod_asia/ig/gateway` - Deploy an IG gateway in the Asia production 
    environment.   


## Migration Workflow

Migrate from one environment to another by copying files, and then adjusting the 
files as required. 

The following is an example workflow that you might use to configure AM as an 
OAuth 2.0 server. In this workflow, you initialize your configuration repository
to support development, QA, and production environment, and then you perform 
development in the development environment and migrate to the QA and production 
environments as follows:

* __Initialization.__ Create the `dev`, `qa`, and `prod` environment directories
in your configuration repository, and copy the 
`default/am/empty-import` directory to the `dev/am/oauth2` directory. Then 
orchestrate the AM and DS deployment example, specifying the `dev/am/oauth2` 
directory as the `configPath`.
* __Development.__ Log in to the AM console and configure AM as necessary. The 
`git` container periodically exports the configuration to the `autosave_am` 
branch. When you are ready to move the configuration to QA, merge a pull request 
on the `autosave_am` branch into the `master` branch. Then copy the 
configuration files to the `qa/am/oauth2` directory. You could do this by 
triggering a Git commit hook that runs a script that copies the files and 
performs environment-specific search and replace. For example, you might need to
 replace development server names with QA server names. You can create 
 additional tools or scripts to automate this process.
* __QA.__ Orchestrate the ForgeRock Identity Platform, specifying the 
`qa/am/oauth2` directory as the `configPath`. Conduct QA testing. If 
configuration changes need to be made as a result of QA testing, make the 
changes in the `dev` configuration, merge them into the `qa` configuration, 
and reiterate testing. When testing is complete, copy the configuration files 
into the `prod/am/oauth2` directory.    
* __Production.__ Orchestrate the ForgeRock Identity Platform, specifying the 
`prod/am/oauth2` directory as the `configPath`. 

Notes:

1. You can configure automated CI/CD tools to run checks at various points in 
the workflow to validate that your configuration is functional.
1. Configuration that is consistent in all environments can reside in the
`common` directory. Merge the features in common/ into the target environment
as necessary.