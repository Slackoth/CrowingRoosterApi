var db = require('../db/connection')

const confirmSale = async (req,res) => {
    const body = req.body
    const saleId = req.query.ventaId
    var payment

    if(req.body.payment == 'Efectivo') {
        payment = 1
    }
    else {
        payment = 2
    }

    await db.connection.any(`select * from confirm_sale('${saleId}',${body.price},
    ${payment},'${body.hour}','${body.address}')`)
    .then(data => {
        return res.status(200).send(data)
    })
    .catch(err => {
        console.log(err);
        
    })
    
}

module.exports = {confirmSale}