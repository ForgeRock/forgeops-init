diff --git tmp/forgecloud/default/README.md 6.5/smoke-tests/README.md
index ab4c281..fc49bcf 100644
--- tmp/forgecloud/default/README.md
+++ 6.5/smoke-tests/README.md
@@ -1,76 +1,28 @@
-# Default ForgeCloud Configuration Notes
+# Smoke-tests configs
+These configs are used for postcommit testing of forgeops deployed into k8s cluster.
 
-The following notes describe what modifications have been made to base AM/IDM/etc configurations.
 
-## AM 6.0
+## AM Configuration
+This configuration is used for following deployment:
+ - 1x external configstore(configstore-0.configstore)
+ - 1x external userstore(userstore-0.userstore)
+ - 1x external CTS store(ctsstore-0.ctsstore)
 
-Configuration is determined by comparing exported Amster files before a change is made in the UI and then after.
+Other customizations include:
+ - OAuth2 provider
+ - OAuth2 client
+ - Two web agent profiles(used for agents tests)
 
-### global/IdRepositoryUser/amAdmin.json
 
-- data.userPassword = &{amadmin.password.hashed}
-- **remove** data.userPassword-encrypted
+## IDM Configuration
+This configuration is used with following deployment:
+ - 1x postgres-openidm
+ - 1x external userstore used for sync tests(userstore-0.userstore)
 
-**NOTE:** To hash the `amAdmin` password see AM Java source code `org.forgerock.openam.shared.security.crypto.Hashes.secureHash(s)`
+Customizations include:
+ - Bidirectional sync to ldap(userstore)
+ - Selfservice registration enabled
+ - Selfservice password reset enabled
 
-### global/DefaultCtsDataStoreProperties.json
-
-- "org.forgerock.services.cts.store.location" : "external"
-- "org.forgerock.services.cts.store.root.suffix" : "ou=famrecords,ou=openam-session,ou=tokens,o=cts"
-- "org.forgerock.services.cts.store.directory.name" : "ctsstore-0.ctsstore:1389"
-- "org.forgerock.services.cts.store.loginid" : "cn=Directory Manager"
-- "org.forgerock.services.cts.store.password" : "password"
-- **remove** "org.forgerock.services.cts.store.password-encrypted"
-
-### global/Servers/01/CtsDataStoreProperties.json
-
-- "org.forgerock.services.cts.store.location" : { "value" : "external" }
-- "org.forgerock.services.cts.store.root.suffix" : {  "value" : "ou=famrecords,ou=openam-session,ou=tokens,o=cts" }
-- "org.forgerock.services.cts.store.directory.name" : { "value" : "ctsstore-0.ctsstore:1389" }
-- "org.forgerock.services.cts.store.loginid" : { "value" : "cn=Directory Manager" }
-- "org.forgerock.services.cts.store.password" : { "value" : "password" }
-- **remove** "org.forgerock.services.cts.store.password-encrypted"
-
-### global/Monitoring.json
-
-- data.enabled = true
-
-### global/PrometheusReporter/prometheus.json
-
-- data.enabled = true
-- data.password = &{prometheus.password}
-- **remove** data.password-encrypted
-
-### global/Realms/root.json
-
-- data.aliases = [ "userstore", "openam", "&{fqdn}" ]
-
-### global/Sites/site1.json
-
-- data.url = http://&{fqdn}/openam
-
-## IDM 6.0
-
-Perform a diff of files in the configuration directory structure, compared to the default configuration directory structure of IDM, to determine what customizations are important.
-
-### conf/authentication.json
-
-- `STATIC_USER` with `"runAsProperties"` configured, so that we can use the run-as header
-
-### conf/endpoint-staticuser.json
-
-File added, because it was provided to us, but not fully understood. May not be needed.
-
-### conf/managed.json
-
-- Removed `require('aliasList').update(object);` from "onUpdate" hook, because it was breaking, but may be needed when social providers are integrated
-- Alter "cannot-contain-others" password policy to only disallow "userName"
-- Removed "givenName" and "sn" from array of "required" Managed User fields
-
-### conf/provisioner.openicf-ldap.json
-
-File added to enable use of `openidm/info/login` REST endpoint, for verifying Managed User credentials.
-
-### conf/repo.ds.json
-
-Configured to point to an external DJ instance named "configstore", which is the shared AM userstore instance.
\ No newline at end of file
+## IG Configuration
+This configuration is just default one with landing page to ensure we can reach IG after deployment is done
