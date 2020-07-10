var express = require('express')
var router = express.Router()
var controller = require('../controllers/sellerController')

/*GET METHODS*/
router.get('/specific',controller.getSpecific)
router.get('/free', controller.getFree)

module.exports = router