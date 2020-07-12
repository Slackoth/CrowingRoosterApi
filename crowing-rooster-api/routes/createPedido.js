var express = require('express')
var router = express.Router()
const controller = require('../controllers/PedidoCreateController')

/*POST*/
router.post('/',controller.confirmPedido)

module.exports = router