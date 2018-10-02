# Smoke-tests configs
These configs are used for postcommit testing of forgeops deployed into k8s cluster.


## AM Configuration
This configuration is used for following deployment:
 - 1x external configstore(configstore-0.configstore)
 - 1x external userstore(userstore-0.userstore)
 - 1x external CTS store(ctsstore-0.ctsstore)

Other customizations include:
 - OAuth2 provider
 - OAuth2 client
 - Two web agent profiles(used for agents tests)


## IDM Configuration
This configuration is used with following deployment:
 - 1x postgres-openidm
 - 1x external userstore used for sync tests(userstore-0.userstore)

Customizations include:
 - Bidirectional sync to ldap(userstore)
 - Selfservice registration enabled
 - Selfservice password reset enabled

## IG Configuration
This configuration is just default one with landing page to ensure we can reach IG after deployment is done
