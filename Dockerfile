# Builds production version of tc-bus-api inside Docker container,
# and runs it against the specified Topcoder backend (development or
# production) when container is executed.

FROM node:8.2.1
LABEL app="tc-bus-api" version="1.0"

WORKDIR /opt/app
COPY . .
#ADD envsh.sh /opt/app/envsh.sh
#RUN chmod 755 envsh.sh
RUN npm install
# dotenv is required for retriving postgres env
#RUN npm install dotenv --save
#RUN cat .env
RUN pwd
RUN ls -la
RUN npm test
ENV NODE_ENV=$NODE_ENV
#ENTRYPOINT ["./envsh.sh"]
CMD ["npm", "start"]

