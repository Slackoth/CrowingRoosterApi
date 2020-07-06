var express = require('express')
var router = express.Router()
var controller = require('../controllers/salePreviewController')

router.get('/all',controller.getSalePreview)

module.exports = router