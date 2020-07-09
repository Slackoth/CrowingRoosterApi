var express = require('express')
var router = express.Router()
var controller = require('../controllers/productController')

/*GET METHODS*/
router.get('/specific',controller.getSpecific)
router.get('/all',controller.getall)

module.exports = router