var db = require('../db/connection')

const getBuyer = async (req,res) => {
    const code = req.query.codigo
    await db.connection.any(`select c.codigo,u.nombre,e.nombre_empresa as empresa,
    c.dui,c.email,t.telefono,u.img 
    from comprador c inner join usuario u 
    on u.id = c.codigo inner join empresa e 
    on e.id_empresa = c.id_empresa inner join telefono t 
    on t.comprador_codigo = c.codigo
    where c.codigo = '${code}';
    `)
    .then(data => {
        return res.status(200).json(data)
    })
    .catch(err => {
        console.log(err)
    })
}

module.exports = {getBuyer}