var express = require('express')
var router = express.Router()
var controller = require('../controllers/orderPreviewController')

router.get('/successful',controller.getSuccessfulOrderPreview)
router.get('/ongoing',controller.getOngoingOrderPreview)

module.exports = router