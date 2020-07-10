var express = require('express')
var router = express.Router()
var controller = require('../controllers/OrdertoChartController')


router.post('/',controller.postOrder)


module.exports = router