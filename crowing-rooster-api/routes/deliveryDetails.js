var express = require('express')
var router = express.Router()
var controller = require('../controllers/deliveryDetailsController')

router.get('/successful', controller.getSuccessfulDeliveryDetails)
router.get('/ongoing', controller.getOngoingDeliveryDetails)

module.exports = router