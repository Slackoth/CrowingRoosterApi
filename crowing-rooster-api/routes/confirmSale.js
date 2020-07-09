var express = require('express')
var router = express.Router()
const controller = require('../controllers/confirmSaleController')

/*POST*/
router.post('/',controller.confirmSale)

module.exports = router