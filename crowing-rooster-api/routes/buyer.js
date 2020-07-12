var express = require('express')
var router = express.Router()
var controller = require('../controllers/buyerController')

router.get('/',controller.getBuyer)

module.exports = router