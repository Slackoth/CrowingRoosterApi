var express = require('express')
var router = express.Router()
var controller = require('../controllers/OrdertoChartController')


router.post('/',controller.CreateOrder)
router.get('/code', controller.getCode)


module.exports = router