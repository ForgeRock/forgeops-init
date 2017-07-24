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
 
Other configuration strategies are possible, including the following:

  * On Minikube, mapping a local configuration folder on your workstation to a 
    Kubernetes volume.
  * Creating immutable Docker containers by cloning the configuration repository 
    and copying the files into the container as part of the build process.

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
       
The following are examples of sets of configuration files provided in the 
skeleton configuration:
       
  * `default/idm/sync-with-ldap-bidirectional` - Contains configuration that 
    implements bidirectional data synchronization between IDM and LDAP.
  * `default/am/amster-sample1` - Contains configuration that implements AM
    configured as follows:
      * A second realm has been added to the AM configuration.
      * AM is configured to act as an OpenID Connect 1.0 server.
    
The following set of configuration files is supported by ForgeRock:

  * `default/am/empty-import` - Contains configuration that implements a
    minimally configured AM server.
    
_All other sets of configuration files in this skeleton configuration 
repository are considered samples that are available for modeling configuration
but are not supported by ForgeRock._     

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