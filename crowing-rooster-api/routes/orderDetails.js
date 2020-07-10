var express = require('express')
var router = express.Router()
var controller = require('../controllers/orderDetailsController')

router.get('/successful',controller.getSuccessfulOrderDetails)
router.get('/ongoing',controller.getOngoingOrderDetails)

module.exports = router