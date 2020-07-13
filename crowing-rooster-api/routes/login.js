var express = require('express')
var router = express.Router()
var controller = require('../controllers/loginController')

router.get('/',controller.getUser)
router.get('/company',controller.getCompanies)


module.exports = router