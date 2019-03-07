FROM forgerock-docker-public.bintray.io/forgerock/end-user-ui:7.0.0-SNAPSHOT

WORKDIR /tmp/end-user-ui

RUN git remote add jakefeasel https://github.com/jakefeasel/end-user-ui.git && git fetch jakefeasel && git checkout oauth2EmbeddedLogin7.0

RUN npm install && npm run build

WORKDIR /tmp/end-user-ui/dist
