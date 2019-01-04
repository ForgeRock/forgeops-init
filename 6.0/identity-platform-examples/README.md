# Identity Platform Examples

### Configuration Example: Custom AM Server with multiple DJ stores 

***sub-directory:*** *am-ds*

This sample populates an AM server with the following configuration.

* 1 x CTS store
* 1 x Config/User store
* OAuth2/OIDC Provider
* OAuth2 client
* Prometheus monitoring endpoint enabled

Peformance enhanced have been configured below:

* CTS Max Connections = 66
* Added new advanced setting: org.forgerock.services.cts.reaper.cache.size = 5000000
* LDAP Connection Pool Maximum Size = 32

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
    version: &{version}
    ctsStores: ctsstore-0.ctsstore:1389,ctsstore-1.ctsstore:1389
    ```

### IDM with AM authentication sharing the same DS userstore.

***sub-directory:*** *idm-am-integration-shared-ds*

This example shows an integration of IDM with AM where both products share the same DS userstore and also AM provides authentication for IDM at both UI-Admin and UI-User levels. Also, IDM uses the same DS for its repository.
