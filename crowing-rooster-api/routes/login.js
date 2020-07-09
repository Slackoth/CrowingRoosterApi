var express = require('express')
var router = express.Router()
var controller = require('../controllers/loginController')

router.get('/',controller.getUser)


module.exports = router