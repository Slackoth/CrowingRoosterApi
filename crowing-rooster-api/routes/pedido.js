var express = require('express')
var router = express.Router()
var controller = require('../controllers/pedidoController')
const { post } = require('../app')

/*GET METHODS*/
router.post('/', addPedido)


module.exports = router
