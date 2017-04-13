#!/usr/bin/env bash
# Fix up FQDN in amster

FROM=openam.example.com
TO=openam.homeunix.org

# This shows where the fqdn is
find . -name \*.json -exec grep $FROM {} \;

# This edits the file in place
echo "Run the following command to replace FQDN names"
echo find . -name \*.json -exec sed -e "s/${FROM}/${TO}/" -i '' {} \;
