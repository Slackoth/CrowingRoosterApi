var express = require('express')
var router = express.Router()
var controller = require('../controllers/sellerClientController')

/*GET METHODS*/
router.get('/all',controller.getAll)

module.exports = router