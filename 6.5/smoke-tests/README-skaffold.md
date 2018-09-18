# Smoke test: Using skaffold


<aside class="warning">
Skaffold needs access to the helm/ charts. The helm/ directory is a symbolic link to your forgeopps helm/ charts. You need to verify this is correct for your environment.
</aside>

The skaffold files do not start any directory services.  Start the directory using helm commands. The directory
takes a while to come up - so it is easier to iterate if you keep it running.

Example:

```bash
helm install --name config --set djInstance=configstore helm/ds
```


The skaffold configuration sets the config.strategy to `docker`. The helm charts use this to exclude the git init containers that 
clone from git. The frconfig chart will be ignored when using skaffold, as the configuration is assumed to be in the image. 

