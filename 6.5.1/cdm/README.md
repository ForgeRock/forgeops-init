Copyright
=========
Copyright 2014-2018 ForgeRock AS. All Rights Reserved

Use of this code requires a commercial software license with ForgeRock AS.
or with one of its affiliates. All use shall be exclusively subject
to such license between the licensee and ForgeRock AS.

# CDM Sample Config

### What is in this config repository?
- This config repo is needed for the charts under `forgeops/samples/config/prod`
- These repos get mounted under `/git` on each pod via the corresponding forgeops helm charts
- Refer to https://github.com/ForgeRock/forgeops/blob/master/samples/config/prod/README.md for further details

### Common Config
- Prometheus endpoints exposed
- Logging to stdout
- Tuned for performance such as Connection Pools and Product specific tunables

### AM Config
- Single realm
- OAuth 2.0 Server and Client
- Separate userstore, configstore and ctsstore
- CTS with Affinity across two servers
- LDAP Auth module default
- Stateful sessions and stateful OAuth 2.0
- All connection pools tuned
- Using DS TTL for token reaping and the new GrantSet Token Storage Scheme
	- Refer to the product documents on some limitions on notifications caused by using DS TTL
- To log into admin console specify the "adminconsoleservice" as query parameter.  For example
	- https://login.example.com/XUI/?service=adminconsoleservice

### IDM Config
- PostgreSQL as repo
- Synchronization to LDAP (userstore)
- This sample demonstrates bidirectional synchronization between an LDAP directory and an OpenIDM repository. 
	- For documentation relating to this sample, see https://backstage.forgerock.com/docs/idm/samples-guide/index.html#chap-sync-with-ldap-bidirectional



### IG Config
- Reverse Proxy
- Resource Server

