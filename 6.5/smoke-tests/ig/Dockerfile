ARG REPO=gcr.io/engineering-devops/openig
ARG TAG=6.5.0
FROM $REPO:$TAG
#FROM gcr.io/engineering-devops/openig:6.5.0

COPY --chown=forgerock config/ /git/config

# IG wants to create files under /git/{logs,scripts}
USER root
RUN chown -R forgerock:forgerock /git 
USER forgerock

