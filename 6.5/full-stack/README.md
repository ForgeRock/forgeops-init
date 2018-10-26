
This is a full product stack integration (AM/IDM/IG/DS) that implements an example of an OAuth2 platform. The main idea of this example is:  IG protecting IDM as an OAuth2 Resource Server for end-user interaction. DS is a shared userstore for both AM and IDM. The example works with an OAuth2 public client which implements an end-user UI. The UI will initiate a PKCE-based OAuth2 flow with AM and will end up with an access token that it includes with each request to the IDM REST endpoints.

