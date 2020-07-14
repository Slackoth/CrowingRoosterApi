var express = require('express')
var router = express.Router()
var controller = require('../controllers/confirmDeliveryController')

router.post('/',controller.confirmDelivery)

module.exports = router