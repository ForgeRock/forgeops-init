Copyright
===========================================================================================
Copyright 2014-2017 ForgeRock AS. All Rights Reserved

Use of this code requires a commercial software license with ForgeRock AS.
or with one of its affiliates. All use shall be exclusively subject
to such license between the licensee and ForgeRock AS.

m-cluster Sample
===========================================================================================
This IDM configuration is associated with the forgeops/config/prod/m-cluster sample.
This coniguration uses OpenDJ as its repository. See conf/repo.ds.json for further details.

### What is in this config repository?
IDM config repos that get mounted under /git on each pod via
the charts 

### Common Config
- Prometheus endpoints exposed
- Logging to stdout
- Tuned for m-cluster

### IDM Config
- Postgres as repo
- Syncronization to LDAP