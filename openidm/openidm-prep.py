#!/usr/bin/env python3
import os
import shutil
import glob



def copy_and_overwrite(from_path, to_path):
    if os.path.exists(to_path):
        shutil.rmtree(to_path)
    shutil.copytree(from_path, to_path)


def main():
    """Example python script to fix up the openidm sample with our custom files"""

    #  hack - find a better way to locate the current openidm release
    idm_source_folder = "/Users/warren.strange/tmp/fr/forgeops/docker/tmp/openidm/samples"

    basedir = "sync-with-ldap-bidirectional"
    confdir = '%s/conf' % basedir

    # Copy the sample files from openidm distro
    copy_and_overwrite("{}/{}".format(idm_source_folder, basedir), basedir)

    # remove orientdb as we are using a custom repo - ignore errors
    try:
        #os.remove('%s/conf/repo.orientdb.json' % basedir)
        os.remove('%s/conf/repo.opendj.json' % basedir)
    except OSError as err:
        print( "error {0} - but you can ignore this".format(err))
        pass

    # copy our custom files in
    for tfile in glob.glob(r'diff/conf/*.json'):
        print ("cp %s %s" % (tfile, confdir))
        shutil.copy(tfile, confdir)



if __name__ == "__main__":
    main()
