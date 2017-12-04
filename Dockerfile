# Builds production version of tc-bus-api inside Docker container,
# and runs it against the specified Topcoder backend (development or
# production) when container is executed.

FROM node:8.2.1
LABEL app="tc-bus-api" version="1.0"
RUN apt-get update
WORKDIR /opt/app
COPY . .
ARG KAFKA_URL 
ARG KAFKA_CLIENT_CERT 
ARG KAFKA_CLIENT_CERT_KEY
ENV KAFKA_URL=$KAFKA_URL 
ENV KAFKA_CLIENT_CERT=$KAFKA_CLIENT_CERT 
ENV KAFKA_CLIENT_CERT_KEY=$KAFKA_CLIENT_CERT_KEY
RUN echo $KAFKA_CLIENT_CERT
RUN npm install
#RUN npm test
#ENV NODE_ENV=$NODE_ENV
#ENTRYPOINT ["/usr/local/bin/npm", "start"]
#CMD [ "npm", "start"]
ENTRYPOINT ["npm", "start"]