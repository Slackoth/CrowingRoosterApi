var express = require('express')
var router = express.Router()
var controller = require('../controllers/saleDetailsController')

router.get('/successful',controller.getSuccessfulSaleDetails)
router.get('/ongoing',controller.getOngoingSaleDetails)

module.exports = router