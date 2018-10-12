'use strict'
const awsServerlessExpress = require('aws-serverless-express')
const app = require('./index')
const server = awsServerlessExpress.createServer(app)

exports.handler = (event, context) => { 
  console.log("events", event)
  console.log("context", context)
  return awsServerlessExpress.proxy(server, event, context)
  
}
