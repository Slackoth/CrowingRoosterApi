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

const getCompanies = async (req,res) => {
    await db.connection.any(`select nombre_empresa from empresa e`)
    .then(data => {
        return res.status(200).json(data)
    })
    .catch(err => {
        console.log(err)
    })
}

module.exports = {getUser,getCompanies}