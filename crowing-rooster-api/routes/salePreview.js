var express = require('express')
var router = express.Router()
var controller = require('../controllers/salePreviewController')

router.get('/successful',controller.getSuccessfulSalePreview)
router.get('/ongoing',controller.getOngoingSalePreview)

module.exports = router