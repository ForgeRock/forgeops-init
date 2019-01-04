Copyright
=========
Copyright 2014-2017 ForgeRock AS. All Rights Reserved

Use of this code requires a commercial software license with ForgeRock AS.
or with one of its affiliates. All use shall be exclusively subject
to such license between the licensee and ForgeRock AS.

# m-cluster (CDM) Sample Config

### What is in this config repository?
AM and IDM config repos that get mounted under /git on each pod via
the charts 

### Common Config
- Prometheus endpoints exposed
- Logging to stdout
- Tuned for m-cluster


### AM Config
- Single realm
- OAuth 2.0 Server and Client
- Separate userstore, configstore and ctsstore
- LDAP Auth module default

### IDM Config (Bi-directional LDAP Sync With Internal Repository Sample)

This sample demonstrates bidirectional synchronization between an LDAP directory
and an OpenIDM repository. For documentation relating to this sample, see
https://ea.forgerock.com/docs/idm/samples-guide/index.html#chap-sync-with-ldap-bidirectional

- Postgres as repo
- Syncronization to LDAP


