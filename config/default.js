/**
 * The default configuration.
 */
//console.log(' process.env.KAFKA_TOPIC_PREFIX  :', process.env.KAFKA_TOPIC_PREFIX)

module.exports = {
  //LOG_LEVEL: process.env.LOG_LEVEL || 'debug',
  //CONTEXT_PATH: process.env.CONTEXT_PATH || '/api/v1',
  //PORT: process.env.PORT || 3000,
  //ALLOWED_SERVICES: process.env.ALLOWED_SERVICES || [
    //'project-service',
    //'challenge-service',
    //'message-service'
  //],
  //JWT_TOKEN_SECRET: process.env.JWT_TOKEN_SECRET || 'JWT_TOKEN_SECRET',
  //JWT_TOKEN_EXPIRES_IN: process.env.JWT_TOKEN_EXPIRES_IN || '100 days',
  //KAFKA_TOPIC_PREFIX: process.env.KAFKA_TOPIC_PREFIX || 'joan-26673.notifications.'

  LOG_LEVEL: process.env.LOG_LEVEL,
  CONTEXT_PATH: process.env.API_VERSION,
  PORT: process.env.PORT || 3000,
  ALLOWED_SERVICES: process.env.ALLOWED_SERVICES,
  JWT_TOKEN_SECRET: process.env.JWT_TOKEN_SECRET,
  JWT_TOKEN_EXPIRES_IN: process.env.JWT_TOKEN_EXPIRES_IN,
  KAFKA_TOPIC_PREFIX: process.env.KAFKA_TOPIC_PREFIX
}
