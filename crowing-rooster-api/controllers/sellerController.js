const db = require('../db/connection')

const getSpecific = async (req,res) => {
    const codigo = req.query.codigo

    const seller = await db.connection.any(`select v.codigo,u.nombre,
    v.email,u.img,t.telefono from 
    vendedor v inner join usuario u 
    on v.codigo = u.id inner join telefono t 
    on v.codigo = t.vendedor_codigo 
    where v.codigo = '${codigo}'`)
    .then(data => {
        return res.status(200).json(data)
    })
    .catch(err => {
        console.log(err)
    })
}

module.exports = {getSpecific}