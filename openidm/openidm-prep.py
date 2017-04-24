#!/usr/bin/env python3
import os
import shutil
import glob


def main():
    """Example python script to fix up the openidm sample with our custom files"""
    basedir = "./openidm/sync-with-ldap-bidirectional"
    confdir = '%s/conf' % basedir
    # remove orientdb as we are using a custom repo
    try:
        os.remove('%s/conf/repo.orientdb.json' % basedir)
    except OSError:
        pass
    # copy our custom files in
    for tfile in glob.glob(r'%s/diff/conf/*.json' % basedir):
        print ("cp %s %s" % (tfile, confdir))
        shutil.copy(tfile, confdir)



if __name__ == "__main__":
    main()
