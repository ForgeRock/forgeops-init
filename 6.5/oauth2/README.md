# Platform OAuth2 Sample

This is a sample project demonstrates one way to use four components of the ForgeRock Identity Platform (AM, DS, IDM and IG). This sample demonstrates these capabilities:

IG protecting IDM as an OAuth2 Resource Server for end-user interaction

External DS cluster as a shared user store for AM and IDM

**There is no OAuth2 client shipped with this sample**. Refer to the [Example OAuth 2 Clients Project](https://github.com/ForgeRock/exampleOAuth2Clients) to find a sample client that will be the most useful for your needs.

 - "amster" contains the AM configuration
 - "rs" contains the IG configuration
 - "idm" contains the IDM configuration

The main helm chart that these configuration files are designed to work with is found in forgeops, under helm/cmp-oauth2.
