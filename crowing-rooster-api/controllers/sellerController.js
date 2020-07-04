const db = require('../db/connection')

const getSpecific = async (req,res) => {
    const codigo = req.query.codigo

    const seller = await db.connection.any(`SELECT v.codigo,u.nombre,v.email,u.img,t.telefono FROM usuario u 
    INNER JOIN vendedor v ON u.id = v.codigo 
    INNER JOIN telefono t ON t.vendedor_codigo = v.codigo 
    WHERE v.codigo = '${codigo}';`)
    .then(data => {
        return res.status(200).json(data)
    })
    .catch(err => {
        console.log(err)
    })
}

module.exports = {getSpecific}