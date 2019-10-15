# Platform Deployment

This is a sample project demonstrates using AM and IDM with DS as their common repo.

## Accessing the running platform

Find the URL to login with using this command:
```
echo https://`kubectl get ing -o jsonpath="{.items[0].spec.rules[0].host}" -l chart=openam-6.5.0`/console
```
Open that URL and you will be redirected to the AM login page.

You can use amadmin / password to login as the AM admin.

You can use user.0  / password to login as a basic end-user.
