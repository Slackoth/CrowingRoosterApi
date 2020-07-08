const db = require('../db/connection')

const getAll = async (req,res) => {
    const codigo = req.query.codigo
    const clients = await db.connection.any(`select p.comprador_codigo,
    u.nombre,c.email,e.nombre_empresa,u.img,t.telefono 
    from venta v inner join ventaxorden v2 
    on v.id_venta = v2.id_venta inner join orden o 
    on o.codigo_orden = v2.codigo_orden inner join pedido p 
    on p.codigo_orden = o.codigo_orden inner join usuario u 
    on p.comprador_codigo = u.id inner join comprador c 
    on p.comprador_codigo = c.codigo inner join empresa e 
    on c.id_empresa = e.id_empresa inner join telefono t 
    on p.comprador_codigo = t.comprador_codigo inner join vendedor v3
    on v.vendedor_codigo = v3.codigo
    where v.vendedor_codigo = '${codigo}'
    group by p.comprador_codigo,p.comprador_codigo,u.nombre,
    c.email,e.nombre_empresa,u.img,t.telefono;
    `)
    .then(data => {
        return res.status(200).json(data)
    })
    .catch(err => {
        console.log(err)
    })
}

module.exports = {getAll}