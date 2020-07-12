var express = require('express')
var router = express.Router()
var controller = require('../controllers/catalogueController')

router.get('/all', controller.getall)

module.exports = router