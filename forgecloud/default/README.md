# Default ForgeCloud Configuration Notes

The following notes describe what modifications have been made to base AM/IDM/etc configurations.

## AM 6.0

Configuration is determined by comparing exported Amster files before a change is made in the UI and then after.

### global/IdRepositoryUser/amAdmin.json

- data.userPassword = &{amadmin.password.hashed}
- **remove** data.userPassword-encrypted

**NOTE:** To hash the `amAdmin` password see AM Java source code `org.forgerock.openam.shared.security.crypto.Hashes.secureHash(s)`

### global/DefaultCtsDataStoreProperties.json

- "org.forgerock.services.cts.store.location" : "external"
- "org.forgerock.services.cts.store.root.suffix" : "ou=famrecords,ou=openam-session,ou=tokens,o=cts"
- "org.forgerock.services.cts.store.directory.name" : "ctsstore-0.ctsstore:1389"
- "org.forgerock.services.cts.store.loginid" : "cn=Directory Manager"
- "org.forgerock.services.cts.store.password" : "password"
- **remove** "org.forgerock.services.cts.store.password-encrypted"

### global/Servers/01/CtsDataStoreProperties.json

- "org.forgerock.services.cts.store.location" : { "value" : "external" }
- "org.forgerock.services.cts.store.root.suffix" : {  "value" : "ou=famrecords,ou=openam-session,ou=tokens,o=cts" }
- "org.forgerock.services.cts.store.directory.name" : { "value" : "ctsstore-0.ctsstore:1389" }
- "org.forgerock.services.cts.store.loginid" : { "value" : "cn=Directory Manager" }
- "org.forgerock.services.cts.store.password" : { "value" : "password" }
- **remove** "org.forgerock.services.cts.store.password-encrypted"

### global/Monitoring.json

- data.enabled = true

### global/PrometheusReporter/prometheus.json

- data.enabled = true
- data.password = &{prometheus.password}
- **remove** data.password-encrypted

### global/Realms/root.json

- data.aliases = [ "userstore", "openam", "&{fqdn}" ]

### global/Sites/site1.json

- data.url = http://&{fqdn}/openam

## IDM 6.0

Perform a diff of files in the configuration directory structure, compared to the default configuration directory structure of IDM, to determine what customizations are important.

### conf/authentication.json

- `STATIC_USER` with `"runAsProperties"` configured, so that we can use the run-as header

### conf/endpoint-staticuser.json

File added, because it was provided to us, but not fully understood. May not be needed.

### conf/managed.json

- Removed `require('aliasList').update(object);` from "onUpdate" hook, because it was breaking, but may be needed when social providers are integrated
- Alter "cannot-contain-others" password policy to only disallow "userName"
- Removed "givenName" and "sn" from array of "required" Managed User fields

### conf/provisioner.openicf-ldap.json

File added to enable use of `openidm/info/login` REST endpoint, for verifying Managed User credentials.

### conf/repo.ds.json

Configured to point to an external DJ instance named "configstore", which is the shared AM userstore instance.