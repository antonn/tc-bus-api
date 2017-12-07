/**
 * The default configuration.
 */

console.log(' process.env.KAFKA_CLIENT_CERT  :', process.env.KAFKA_CLIENT_CERT);
console.log(' process.env.KAFKA_CLIENT_CERT_KEY  :', process.env.KAFKA_CLIENT_CERT_KEY);
console.log(' process.env.KAFKA_TOPIC_PREFIX  :', process.env.KAFKA_TOPIC_PREFIX);
console.log(' process.env.KAFKA_URL  :', process.env.KAFKA_URL);
console.log(' process.env.ALLOWED_SERVICES  :', process.env.ALLOWED_SERVICES);


module.exports = {
    KAFKA_CLIENT_CERT: process.env.KAFKA_CLIENT_CERT ? process.env.KAFKA_CLIENT_CERT.replace('\\n', '\n') : null,
  KAFKA_CLIENT_CERT_KEY: process.env.KAFKA_CLIENT_CERT_KEY ? process.env.KAFKA_CLIENT_CERT_KEY.replace('\\n', '\n') : null,
  ALLOWED_SERVICES: process.env.ALLOWED_SERVICES ? process.env.ALLOWED_SERVICES.replace(/\\"/g, '') : null,
  LOG_LEVEL: process.env.LOG_LEVEL,
  CONTEXT_PATH: process.env.API_VERSION,
  PORT: process.env.PORT || 3000,
  ALLOWED_SERVICES: process.env.ALLOWED_SERVICES,
  JWT_TOKEN_SECRET: process.env.JWT_TOKEN_SECRET,
  JWT_TOKEN_EXPIRES_IN: process.env.JWT_TOKEN_EXPIRES_IN,
  KAFKA_TOPIC_PREFIX: process.env.KAFKA_TOPIC_PREFIX
}
