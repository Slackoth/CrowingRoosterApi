var db = require('../db/connection')

const confirmDelivery = async (req,res) => {
    const code = req.query.codigo
    const id = req.query.entregaId
    console.log(code);
    console.log(id);

    await db.connection.any(`select * from confirmar_entrega('${code}',${id})`)
    .then(data => {
        return res.status(200).send(data)
    })
    .catch(err => {
        console.log(err)
    })
}

module.exports = {confirmDelivery}