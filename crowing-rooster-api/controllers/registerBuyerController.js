var db = require('../db/connection')

const registerBuyer = async (req,res) => {
    const body = req.body
    console.log(body);
    
    await db.connection.any(`select * from insertar_comprador('${body.dui}',
    '${body.email}','${body.company}','${body.username}','${body.name}',
    '${body.password}','${body.img}','${body.phone}')`)
    .then(data => {
        return res.status(200).send(data)
    })
    .catch(err => {
        console.log(err);
    })
}

module.exports = {registerBuyer}