'use strict'
const awsServerlessExpress = require('aws-serverless-express')
const app = require('./index')
const server = awsServerlessExpress.createServer(app, null)
exports.handler = (event, context) => { 
  console.log("before events", event)
  console.log("before context", context)
  if (event.headers) {
        let headers = event.headers
        if (headers['Content-Encoding']) {
            delete headers['Content-Encoding']
        }
        if (event.multiValueHeaders) {
            if (event.multiValueHeaders['Content-Encoding']) {
               delete event.multiValueHeaders['Content-Encoding'] 
            }
        }

   }
  console.log("after events", event)
  console.log("after context", context)
  return awsServerlessExpress.proxy(server, event, context)
  
}
