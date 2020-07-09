var express = require('express')
var router = express.Router()
var controller = require('../controllers/deliveryPreviewController')

router.get('/successful',controller.getSuccessfulDeliveryPreview)
router.get('/ongoing',controller.getOngoingDeliveryPreview)

module.exports = router