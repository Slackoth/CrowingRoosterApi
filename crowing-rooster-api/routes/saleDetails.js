var express = require('express')
var router = express.Router()
var controller = require('../controllers/saleDetailsController')

router.get('/successful',controller.getSuccessfulSaleDetails)

module.exports = router