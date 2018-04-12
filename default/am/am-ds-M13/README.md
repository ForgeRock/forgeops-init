Configuration Example: Custom AM Server with multiple DJ stores
===============================================================

This sample populates an AM server with the following configuration.

* 3 x CTS store
* 2 x Config store
* 1 x User store
* Oauth2 client
* OIDC client
* Prometheus monitoring endpoint enabled

This config also uses the following commons parameters.  These values need to be
added to the values override file for amster:
* fqdn (e.g. openam.<namespace>.forgeops.com).
* version (the amster and AM image version used).  If left out, defaults to image.tag.
* cts stores (the name of the cts stores configured).

Example custom.yaml snippet for amster

    ```
    image:
       tag: latest
    # commons parameters
    fqdn: openam.mynamespace.forgeops.com
    version: 6.0.0-M13
    ctsStores: ctsstore-0.ctsstore:1389,ctsstore-1.ctsstore:1389
    ```



