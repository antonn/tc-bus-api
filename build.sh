#!/bin/bash
set -eo pipefail

# Builds Docker image of tc-bus-api application.
# This script expects a single argument: NODE_ENV, which must be either
# "development" or "production".

NODE_ENV=$1

ENV=$1
AWS_REGION=$(eval "echo \$${ENV}_AWS_REGION")
AWS_ACCESS_KEY_ID=$(eval "echo \$${ENV}_AWS_ACCESS_KEY_ID")
AWS_SECRET_ACCESS_KEY=$(eval "echo \$${ENV}_AWS_SECRET_ACCESS_KEY")
AWS_ACCOUNT_ID=$(eval "echo \$${ENV}_AWS_ACCOUNT_ID")
AWS_REPOSITORY=$(eval "echo \$${ENV}_AWS_REPOSITORY") 

#LOG_LEVEL=LOG_LEVEL=$(eval "echo \$${ENV}_LOG_LEVEL")
#NODE_PORT=NODE_PORT=$(eval "echo \$${ENV}_NODE_PORT")
#JWT_SECRET=JWT_SECRET=$(eval "echo \$${ENV}_JWT_SECRET")
#KAFKA_TOPIC_PREFIX=KAFKA_TOPIC_PREFIX=$(eval "echo \$${ENV}_KAFKA_TOPIC_PREFIX")
#API_VERSION=API_VERSION=$(eval "echo \$${ENV}_API_VERSION")
#ALLOWED_SERVICES=ALLOWED_SERVICES=$(eval "echo \$${ENV}_ALLOWED_SERVICES")
#JWT_TOKEN_EXPIRES_IN=JWT_TOKEN_EXPIRES_IN=$(eval "echo \$${ENV}_JWT_TOKEN_EXPIRES_IN")

KAFKA_URL=$(eval "echo \$${ENV}_KAFKA_URL")
KAFKA_CLIENT_CERT=$(eval "echo \$${ENV}_KAFKA_CLIENT_CERT")
KAFKA_CLIENT_CERT_KEY=$(eval "echo \$${ENV}_KAFKA_CLIENT_CERT_KEY")

#append kafka env to shell script

#cat > envsh.sh <<< $KAFKA_URL$'\n'$KAFKA_CLIENT_CERT$'\n'$KAFKA_CLIENT_CERT_KEY
#printf '%s\n%s\n%s' 'export '$KAFKA_URL1 'export '$KAFKA_CLIENT_CERT 'export '$KAFKA_CLIENT_CERT_KEY | tee -a envsh.sh
#chmod 777 envsh.sh

#append environment variable into .env file.
#printf '%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n' $LOG_LEVEL $NODE_PORT $JWT_SECRET $KAFKA_URL $KAFKA_TOPIC_PREFIX $API_VERSION $ALLOWED_SERVICES $JWT_TOKEN_EXPIRES_IN | tee -a .env

# Builds Docker image of the app.
TAG=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/tc-bus-api:$CIRCLE_SHA1

docker build -t $TAG \
  --build-arg NODE_ENV=$NODE_ENV \
  --build-arg KAFKA_URL=$KAFKA_URL \
  --build-arg KAFKA_CLIENT_CERT="$KAFKA_CLIENT_CERT" \
  --build-arg KAFKA_CLIENT_CERT_KEY="$KAFKA_CLIENT_CERT_KEY" .


# Copies "node_modules" from the created image, if necessary for caching.
docker create --name app $TAG

if [ -d node_modules ]
then
  # If "node_modules" directory already exists, we should compare
  # "package-lock.json" from the code and from the container to decide,
  # whether we need to re-cache, and thus to copy "node_modules" from
  # the Docker container.
  mv package-lock.json old-package-lock.json
  docker cp app:/opt/app/package-lock.json package-lock.json
 # docker cp .env app:/opt/app/
  set +eo pipefail
  UPDATE_CACHE=$(cmp package-lock.json old-package-lock.json)
  set -eo pipefail
else
   # If "node_modules" does not exist, then cache must be created.
  UPDATE_CACHE=1
fi

if [ "$UPDATE_CACHE" == 1 ]
then
  docker cp app:/opt/app/node_modules .
fi
