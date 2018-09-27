#!/bin/bash
set -eo pipefail

NODE_ENV=$1
ENV=$1
AWS_REGION=$(eval "echo \$${ENV}_AWS_REGION")
AWS_ACCESS_KEY_ID=$(eval "echo \$${ENV}_AWS_ACCESS_KEY_ID")
AWS_SECRET_ACCESS_KEY=$(eval "echo \$${ENV}_AWS_SECRET_ACCESS_KEY")
AWS_ACCOUNT_ID=$(eval "echo \$${ENV}_AWS_ACCOUNT_ID")

if [[ -z "$ENV" ]] ; then
	echo "Environment should be set on startup with one of the below values"
	echo "ENV must be one of - DEV, QA, PROD or LOCAL"
	exit
fi

LOG_LEVEL=$(eval "echo \$${ENV}_LOG_LEVEL")
JWT_TOKEN_SECRET=$(eval "echo \$${ENV}_JWT_TOKEN_SECRET")
API_VERSION=$(eval "echo \$${ENV}_API_VERSION")
PORT=$(eval "echo \$${ENV}_NODE_PORT")

KAFKA_URL=$(eval "echo \$${ENV}_KAFKA_URL")
KAFKA_CLIENT_CERT=$(eval "echo \$${ENV}_KAFKA_CLIENT_CERT")
KAFKA_CLIENT_CERT_KEY=$(eval "echo \$${ENV}_KAFKA_CLIENT_CERT_KEY")

VALID_ISSUERS=$(eval "echo \$${ENV}_VALID_ISSUERS")

TC_EMAIL_SERVICE_URL=$(eval "echo \$${ENV}_TC_EMAIL_SERVICE_URL")

AUTH0_URL=$(eval "echo \$${ENV}_AUTH0_URL")
AUTH0_AUDIENCE=$(eval "echo \$${ENV}_AUTH0_AUDIENCE")
TOKEN_CACHE_TIME=$(eval "echo \$${ENV}_TOKEN_CACHE_TIME")
AUTH0_CLIENT_ID=$(eval "echo \$${ENV}_AUTH0_CLIENT_ID")
AUTH0_CLIENT_SECRET=$(eval "echo \$${ENV}_AUTH0_CLIENT_SECRET")

template='{"API_VERSION":"%s","AUTH0_AUDIENCE":"%s","AUTH0_CLIENT_ID":"%s","AUTH0_CLIENT_SECRET":"%s","AUTH0_URL":"%s","ENV":"%s","LOG_LEVEL":"%s","JWT_TOKEN_SECRET":"%s","KAFKA_URL":"%s","KAFKA_CLIENT_CERT":"%s","KAFKA_CLIENT_CERT_KEY":"%s","TC_EMAIL_SERVICE_URL":"%s","TOKEN_CACHE_TIME": "%s", "VALID_ISSUERS": %s}'
   
json_string=$(printf "$template" "$API_VERSION" "$AUTH0_AUDIENCE" "$AUTH0_CLIENT_ID" "$AUTH0_CLIENT_SECRET" "$AUTH0_URL" "$ENV" "$LOG_LEVEL" "$JWT_TOKEN_SECRET" "$KAFKA_URL"  "$KAFKA_CLIENT_CERT" "$KAFKA_CLIENT_CERT_KEY" "$TC_EMAIL_SERVICE_URL" "$TOKEN_CACHE_TIME" "$VALID_ISSUERS")

echo $json_string > .config/dev.json

configure_aws_cli() {
	aws --version
	aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
	aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
	aws configure set default.region $AWS_REGION
	aws configure set default.output json
	echo "Configured AWS CLI."
}
