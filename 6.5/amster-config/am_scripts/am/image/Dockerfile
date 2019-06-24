# AM Dockerfile
#
# Copyright (c) 2016-2017 ForgeRock AS.
#
FROM tomcat:8.5.28-jre8-alpine


#ENV CATALINA_OPTS -server -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap
# Option for setting the AM home directory:
#    -Dcom.sun.identity.configuration.directory=/home/forgerock/openam
# Options for using cgroups for memory size:
#   -server -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap
# Option for sending debug output to stderr
#-Dcom.sun.identity.util.debug.provider=com.sun.identity.shared.debug.impl.StdOutDebugProvider -Dcom.sun.identity.shared.debug.file.format="%PREFIX% %MSG%\n%STACKTRACE%"
# -Duser.home=/home/forgerock
# See also https://forum.forgerock.com/topic/openamcfg-location/


# This option:
#  -Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true \
# is disabled to avoid http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2007-0450 
# This may impact amster imports for some configurations (SAML entities)
# If you need to renable this for amster, it should be disabled after the import is complete

ENV CATALINA_OPTS -server -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap \
  -Dcom.sun.identity.util.debug.provider=com.sun.identity.shared.debug.impl.StdOutDebugProvider \
  -Dcom.sun.identity.shared.debug.file.format=\"%PREFIX% %MSG%\\n%STACKTRACE%\"

#  -Dcom.iplanet.services.debug.level=error

ENV FORGEROCK_HOME /home/forgerock
ENV OPENAM_HOME /home/forgerock/openam
ENV AMSTER_HOME /opt/amster
ENV AMSTER_SCRIPTS ${FORGEROCK_HOME}/amster
ENV AMSTER_CONFIG ${FORGEROCK_HOME}/amster-config

COPY scripts/*.sh $FORGEROCK_HOME/
COPY customize $FORGEROCK_HOME/customize

#COPY AM-6.0.0.1.war /tmp/openam.war
#COPY Amster-6.0.0.1.zip /tmp/amster.zip

# Note that we are adding the forgerock user to the root group - which is consistent with OpenShift.
# This is a work around for: https://github.com/docker-library/tomcat/issues/35
RUN apk add --no-cache su-exec unzip curl bash gettext \
  && rm -fr /usr/local/tomcat/webapps/* \
  && curl dihk-idm-dev01.test-server.ag/AM-6.0.0.1.war -o /tmp/openam.war \
  && md5sum /tmp/openam.war | grep 12e6fd55ab4871729e044b5c5cc5133b \
  && unzip -q /tmp/openam.war -d  "$CATALINA_HOME"/webapps/openam \
  && rm /tmp/openam.war \
  && curl dihk-idm-dev01.test-server.ag/am-xui.zip -o /tmp/am-xui.zip \
  && md5sum /tmp/am-xui.zip | grep 69303872b0c1db86734da7e04d226417 \
  && unzip -q -o /tmp/am-xui.zip -d  "$CATALINA_HOME"/webapps/openam \
  && rm /tmp/am-xui.zip \
  && addgroup -g 11111 forgerock \
  && adduser -s /bin/bash -h "$FORGEROCK_HOME" -u 11111 -D forgerock -G root \
  && mkdir -p "$OPENAM_HOME" \
  && mkdir -p "$FORGEROCK_HOME"/.openamcfg \
  && echo "$OPENAM_HOME" >  "$FORGEROCK_HOME"/.openamcfg/AMConfig_usr_local_tomcat_webapps_openam_ \
  && chown -R forgerock:root "$CATALINA_HOME" \
  && chown -R forgerock:root  "$FORGEROCK_HOME" \
  && chmod -R g+rwx "$FORGEROCK_HOME" \
  && chmod -R g+rwx "$CATALINA_HOME"
  
RUN mkdir -p "$AMSTER_HOME" \
  && curl dihk-idm-dev01.test-server.ag/Amster-6.0.0.1.zip -o /tmp/amster.zip \
  && md5sum /tmp/amster.zip | grep 02fd153950772b95ba8ee1d726f81ba0 \
  && unzip -q /tmp/amster.zip -d  "$AMSTER_HOME" \
  && rm /tmp/amster.zip \
  && chown -R forgerock:root "$AMSTER_HOME" \
  && chmod -R g+rwx "$AMSTER_HOME"
  
# am-customization (quick and dirty solution)
RUN curl dihk-idm-dev01.test-server.ag/am-customization-0.0.1-SNAPSHOT.jar -o $CATALINA_HOME/webapps/openam/WEB-INF/lib/am-customization-0.0.1-SNAPSHOT.jar


# The userid must be numeric.
USER 11111

# If you want to create an image that is ready to be bootstrapped to a
# configuration store, you can add a custom boot.json file.
# This can also be added at runtime by a ConfigMap or an init container.
#COPY boot.json /root/openam

# Generate a default keystore for SSL - only needed if you want SSL inside the cluster.
# You can mount your own keystore on the ssl/ directory to override this.
# Because of the complexity of configuring ssl, we should look at using istio.io to handle intercomponent ssl
#RUN mkdir -p /usr/local/tomcat/ssl && \
#   keytool -genkey -noprompt \
#     -keyalg RSA \
#     -alias tomcat \
#     -dname "CN=forgerock.com, OU=ID, O=FORGEROCK, L=Calgary, S=AB, C=CA" \
#     -keystore /usr/local/tomcat/ssl/keystore \
#     -storepass password \
#     -keypass password

# Custom server.xml: use this if AM is behind SSL termination.
# See the server.xml file for details.
COPY server.xml "$CATALINA_HOME"/conf/server.xml

# For debugging AM in a container, uncomment this.
# Use something like  kubectl port-forward POD 5005:5005
# ENV CATALINA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005"

# Settings for Tomcat cache.
COPY context.xml "$CATALINA_HOME"/conf/context.xml


ENTRYPOINT ["/home/forgerock/docker-entrypoint.sh"]

CMD ["run"]
