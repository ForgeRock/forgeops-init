# Default ForgeCloud Configuration Notes

The following notes describe what modifications have been made to base AM/IDM/etc configurations.

## AM 6.0

Configuration is determined by comparing exported Amster files before a change is made in the UI and then after.

### global/Monitoring.json

- data.enabled = true

### global/PrometheusReporter/prometheus.json

- data.enabled = true
- data.password = prometheus
- data.password-encrypted = null

### global/Realms/root.json

- data.aliases = [ "userstore", "openam", "&{fqdn}" ]

### global/Sites/site1.json

- data.url = http://&{fqdn}/openam

## IDM 6.0

TODO :)