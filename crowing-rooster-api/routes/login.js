var express = require('express')
var router = express.Router()
var controller = require('../controllers/loginController')

router.get('/',controller.getUser)
<<<<<<< HEAD
router.get('/deliveryMan',controller.getDeliveryMan)
=======
router.get('/company',controller.getCompanies)
>>>>>>> c26478cf3e96021ed0667181b7a47d8d4f8384f7


module.exports = router