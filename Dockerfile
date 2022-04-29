FROM icr.io/appcafe/open-liberty:kernel-slim-java8-openj9-ubi


RUN pwd
RUN mkdir -p /tmp/app
# Add Liberty server configuration including all necessary features
COPY --chown=1001:0  server.xml /config/
# Modify feature repository (optional)
# A sample is in the 'Getting Required Features' section below
COPY --chown=1001:0 featureUtility.properties /opt/ol/wlp/etc/

# This script will add the requested XML snippets to enable Liberty features and grow image to be fit-for-purpose using featureUtility. 
# Only available in 'kernel-slim'. The 'full' tag already includes all features for convenience.
RUN features.sh

# Add interim fixes (optional)
#COPY --chown=1001:0  interim-fixes /opt/ol/fixes/
WORKDIR /tmp/app/
RUN curl -sSf -H "X-JFrog-Art-Api:$ARGPASS" -O 'https://na.artifactory.swg-devops.com/artifactory/wasliberty-open-liberty/devops/guide-getting-started-main.war'
#RUN curl -sSf -H "X-JFrog-Art-Api:$ARGPASS" -O 'https://na.artifactory.swg-devops.com/artifactory/wasliberty-open-liberty/devops/guide-getting-started.war'
# Add app
RUN pwd
RUN mv guide-getting-started-main.war guide-getting-started.war
RUN chmod 777 /tmp/app/guide-getting-started.war
RUN ls -lrt
RUN pwd
RUN cp /tmp/app/guide-getting-started.war /config/dropins/
RUN chmod 777 /config/dropins/guide-getting-started.war
RUN ls -lrt /config/dropins/
#COPY --chown=1001:0 guide-getting-started.war /config/dropins/
RUN chown 1001:0 /config/dropins/guide-getting-started.war

WORKDIR /
RUN ls -lrt
# This script will add the requested server configurations, apply any interim fixes and populate caches to optimize runtime
RUN configure.sh
