var db = require('../db/connection')

const confirmPedido = async (req,res) => {
    const body = req.body
    console.log(body)
   

    if(req.body.payment == 'Efectivo') {
        payment = 1
    }
    else {
        payment = 2
    }

    await db.connection.any(`insert into pedido values ( Default,'${body.comprador}', ${body.cantidad}, '${body.orden}', ${body.bateria});`)
    .then(data => {
        return res.status(200).send(data)
    })
    .catch(err => {
        console.log(err)
    })
    
}

module.exports = {confirmPedido}