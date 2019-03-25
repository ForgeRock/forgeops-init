FROM forgerock-docker-public.bintray.io/forgerock/am:7.0.0-SNAPSHOT
RUN cp /usr/local/tomcat/webapps/am/XUI/main.*.js /usr/local/tomcat/webapps/am/XUI/main.normalized.js
COPY web-fragment.xml /usr/local/tomcat/webapps/am/WEB-INF
COPY index.html /usr/local/tomcat/webapps/am/XUI
