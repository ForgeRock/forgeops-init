# IG Benchmark config

Helm pre reqs
* frconfig
* openig deployment
* web deployment

This config sets IG with a reverse proxy handler which captures all routes and forwards on to the nginx server(http://web-ig-benchmark:80) deployed as part of the web Helm chart.

The nginx pod returns a simple static web page.

