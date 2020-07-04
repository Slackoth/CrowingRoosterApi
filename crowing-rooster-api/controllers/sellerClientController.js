const db = require('../db/connection')

const getAll = async (req,res) => {
    const clients = await db.connection.any(`SELECT c.codigo,u.nombre,c.email,e.nombre_empresa,u.img,t.telefono FROM usuario u 
    INNER JOIN comprador c ON u.id = c.codigo 
    INNER JOIN empresa e ON e.id_empresa = c.id_empresa 
    INNER JOIN telefono t ON t.comprador_codigo = c.codigo`)
    .then(data => {
        return res.status(200).json(data)
    })
    .catch(err => {
        console.log(err)
    })
}

module.exports = {getAll}