# Platform OAuth2 Sample

This is a sample project demonstrates one way to use four components of the ForgeRock Identity Platform (AM, DS, IDM and IG). This sample demonstrates these capabilities:

IG protecting IDM as an OAuth2 Resource Server for end-user interaction

External DS instance as a shared user store for AM and IDM

**There is no OAuth2 client shipped with this sample**. Refer to the [Example OAuth 2 Clients Project](https://github.com/ForgeRock/exampleOAuth2Clients) to find a sample client that will be the most useful for your needs.

The easiest way to start this configuration is using the instructions found under [development](./development). If you want to run this configuration in a more production-oriented way, you deploy each of these helm charts from forgeops:

 - frconfig
 - amster
 - openig
 - openidm
 - openam
 - ds

You will need to adjust the config path values for amster, openig and openidm to point to the appropriate subfolders under this forgeops-init structure.

 - "amster" contains the amster configuration
 - "rs" contains the openig configuration
 - "idm" contains the openidm configuration

## Accessing the running platform

Find the URL to login with using this command:
```
echo https://`kubectl get ing -o jsonpath="{.items[0].spec.rules[0].host}" -l chart=openam-6.5.0`/console
```
Open that URL and you will be redirected to the AM login page.

You can use amadmin / password to login as the AM admin.

You can use user.0  / password to login as a basic end-user.

The details you need for your OAuth2 clients are as follows:

**Authorization Server Endpoint Base URL**
```
echo https://`kubectl get ing -o jsonpath="{.items[0].spec.rules[0].host}" -l chart=openam-6.5.0`
```
*AS URLs under base*
- /oauth2/authorize
- /oauth2/access_token
- /oauth2/token/revoke

**IDM Resource Server Endpoint Base**
```
echo https://`kubectl get ing -o jsonpath="{.items[0].spec.rules[0].host}" -l chart=openig-6.5.0`/openidm
```

*RS URLs accessible with no access token*
- /info/features
- /info/uiconfig
- /config/ui/themeconfig
- /authentication

*RS URLs accessible with access token having 'consent_read' scope*
- /consent

*RS URLs accessible with access token having 'notifications' scope*
- /endpoint/usernotifications
- /notification
- /internal/notification

*RS URLs accessible with access token having 'openid' scope*
- /authentication
- /privilege
- /info/login
- /info/version
- /config/ui/profile
- /config/ui/dashboard
- /policy
- /schema

*RS URLs under RS base access token having 'profile' scope*
- /managed/user
- /endpoint/static/user

*RS URLs under RS base access token having 'profile_update' scope*
- /managed/user

*RS URLs under RS base access token having 'user_admin' scope*
- /managed/user
- /policy/managed/user

*RS URLs under RS base access token having 'user_admin' scope*
- /managed/user
- /policy/managed/user
