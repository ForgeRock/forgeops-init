#!/bin/bash
# Clean up amster exported files

cd  amster-sample1

# These files get created as part of the install process, so we can safely remove them from exported config
# This helps to eliminate files that need the FQDN fixed up between environments.
rm -f global/Sites/site1.json
rm -f global/Servers/01/DirectoryConfiguration.json
rm -f global/Realms/root.json


#rm -f global/PasswordReset.json


# This file embeds the am version -which triggers upgrade. For testing is OK to remove this, but it is not recommended
# in production...
rm -f global/DefaultAdvancedProperties.json


# Contains fqdn
rm -f realms/root/BaseUrlSource.json
rm -f realms/root/Policies/OAuth2ProviderPolicy.json


rm -f realms/root/SunIdentityRepositoryService.json

