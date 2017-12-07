#!/bin/bash
set -eo pipefail
set -x

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

# LOG_LEVEL=$(eval "echo \$${ENV}_LOG_LEVEL")
# JWT_TOKEN_SECRET=$(eval "echo \$${ENV}_JWT_TOKEN_SECRET")
# KAFKA_TOPIC_PREFIX=$(eval "echo \$${ENV}_KAFKA_TOPIC_PREFIX")
# API_VERSION=$(eval "echo \$${ENV}_API_VERSION")
# ALLOWED_SERVICES=$(eval "echo \$${ENV}_ALLOWED_SERVICES")
# JWT_TOKEN_EXPIRES_IN=$(eval "echo \$${ENV}_JWT_TOKEN_EXPIRES_IN")

# KAFKA_URL=$(eval "echo \$${ENV}_KAFKA_URL")
# KAFKA_CLIENT_CERT_a=$(eval "echo \$${ENV}_KAFKA_CLIENT_CERT")
# KAFKA_CLIENT_CERT_KEY_a=$(eval "echo \$${ENV}_KAFKA_CLIENT_CERT_KEY")
# echo $KAFKA_CLIENT_CERT_a | sed -e 's/\(CERTIFICATE-----\)\s/\1\n/g; s/\s\(-----END\)/\n\1/g' | sed -e '2s/\s\+/\n/g' > keycert.txt
# KAFKA_CLIENT_CERT=$(cat keycert.txt)
# echo $KAFKA_CLIENT_CERT_KEY_a | sed -e 's/\(KEY-----\)\s/\1\n/g; s/\s\(-----END\)/\n\1/g' | sed -e '2s/\s\+/\n/g' > keycertkey.txt
# KAFKA_CLIENT_CERT_KEY=$(cat keycertkey.txt)

# Builds Docker image of the app.
TAG=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/tc-bus-api:$CIRCLE_SHA1

docker build -t $TAG .

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
  #docker cp app:/opt/app/node_modules .
fi
