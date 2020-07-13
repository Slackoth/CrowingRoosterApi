var db = require('../db/connection')

const getUser = async (req,res) => {
    //const email = req.query.email

    await db.connection.any(`(select v.codigo,v.email,u.tipo,u.img from vendedor v left join usuario u 
        on u.id = v.codigo left join comprador c 
        on u.id = c.codigo)
        UNION
        (select c.codigo,c.email,u.tipo,u.img from vendedor v right join usuario u 
        on u.id = v.codigo right join comprador c 
        on u.id = c.codigo)`
        )
        .then(data => {
            return res.status(200).json(data)
        })
        .catch(err => {
            console.log(err)
        })
}

const getDeliveryMan = async(req,res) => {
    await db.connection.any(`select r.codigo, r.email, u.tipo, u.img from repartidor r inner join usuario u
        on u.id = r.codigo;`)
    .then(data =>{
        return res.status(200).json(data)
    })
    .catch(err => {
        console.log(err)
    })
}

module.exports = {getUser, getDeliveryMan}