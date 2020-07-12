var express = require('express')
var router = express.Router()
var controller = require('../controllers/registerBuyerController')

router.post('/',controller.registerBuyer)

module.exports = router