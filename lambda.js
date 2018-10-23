'use strict'
const awsServerlessExpress = require('aws-serverless-express')
const app = require('./index')
//gzip
const binaryMimeTypes = ['gzip', 'application/gzip']
const server = awsServerlessExpress.createServer(app, null, binaryMimeTypes)
exports.handler = (event, context) => { 
  console.log("events", event)
  console.log("context", context)
  return awsServerlessExpress.proxy(server, event, context)
  
}
