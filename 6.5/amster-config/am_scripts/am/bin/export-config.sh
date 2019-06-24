#!/bin/sh

print_usage() {
    echo "$0: CONTAINER TARGET_DIR"
}

if [ ${#} -gt 2 ]; then
    echo "ERROR: Too many enough arguments"
    print_usage
    exit -1
fi

BASEDIR=$(dirname "$0")
CONTAINER=${1:-docker_openam_1}
TARGET_DIR="${2:-$BASEDIR/../project/config}"

docker cp $CONTAINER:/home/forgerock/openam $TARGET_DIR/export
cp -rf $TARGET_DIR/export/* $TARGET_DIR
rm -r $TARGET_DIR/export
