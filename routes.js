/**
 * Configure application routes.
 */
const {Router} = require('express')
const requireDir = require('require-dir')
const auth = require('./common/auth')

const router = Router()
const controllers = requireDir('./controllers')

// Async error handling
const wrap = fn => (...args) => fn(...args).catch(args[2])

// Routes
router.post('/events', auth, wrap(controllers.EventController.create))
router.get('/topics', auth, wrap(controllers.TopicController.getAll))

//module.exports = router

module.exports = {
    router,
    '/health': {
        get: {
          controller: 'HealthController',
          method: 'health',
        },
      },
    }
