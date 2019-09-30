#!/usr/bin/env bash
#
# Copyright (c) 2019 ForgeRock AS. All rights reserved.
#
# Import config with amster.


DIR="/opt/amster"

# Path to script location - this is *not* the path to the amster/*.json config files - it is the path
# to  *.amster scripts.
AMSTER_SCRIPT=${AMSTER_SCRIPT:-"${DIR}/scripts/01_import.amster"}

# Extract amster version for commons parameter to modify configs
cd ${DIR}
echo "Extracting amster version"
VER=$(./amster --version)
[[ "$VER" =~ ([0-9].[0-9].[0-9]-([a-zA-Z][0-9]+|SNAPSHOT|RC[0-9]+)|[0-9].[0-9].[0-9]) ]]
export VERSION=${BASH_REMATCH[1]}
echo "Amster version is: " $VERSION

# Execute Amster if the configuration is found.
if [ -f  ${AMSTER_SCRIPT} ]; then
    if [ ! -r /var/run/secrets/amster/id_rsa ]; then
        echo "ERROR: Can not find the Amster private key"
        exit 1
    fi

    echo "Executing Amster to configure AM"
    # Need to be in the amster directory, otherwise Amster can't find its libraries.
    cd ${DIR}
    echo "Executing Amster script $file"
    sh ./amster $AMSTER_SCRIPT
fi

echo "Configuration script finished"
