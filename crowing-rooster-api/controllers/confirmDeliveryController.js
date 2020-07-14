var db = require('../db/connection')

const confirmDelivery = async (req,res) => {
    const code = req.query.codigo
    const id = req.query.entregaId
    const body = req.body
    console.log(code);
    console.log(id);
    console.log(body);
    

    await db.connection.any(`select * from confirmar_entrega('${code}',${id},${body.price},'${body.payment}')`)
    .then(data => {
        return res.status(200).send(data)
    })
    .catch(err => {
        console.log(err)
    })
}

module.exports = {confirmDelivery}