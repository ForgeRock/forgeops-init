#!/bin/bash
# Does a one shot export of the AM configuration.

set -e

# Default export path - relative to the root.
export EXPORT_PATH="${EXPORT_PATH:-/tmp/export}"

mkdir -p "${EXPORT_PATH}"
rm -rf "${EXPORT_PATH}/*"

# Create Amster export script.
cat > /tmp/do_export.amster <<EOF
connect -k  ${OPENAM_HOME}/amster_rsa http://localhost:8080/openam
export-config --path $EXPORT_PATH
:quit
EOF

pushd $AMSTER_HOME
./amster /tmp/do_export.amster
popd
