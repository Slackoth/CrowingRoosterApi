var db = require('../db/connection')

const getSuccessfulSalePreview = async (req,res) => {
    const codigo = req.query.codigo

    await db.connection.any(`select v.id_venta,u.nombre,ve.fecha_venta,
    sum(p.cantidad_bateria) as total,u.img,o.codigo_orden from venta v inner join ventaxorden v2 
    on v.id_venta = v2.id_venta inner join orden o 
    on o.codigo_orden = v2.codigo_orden inner join pedido p 
    on p.codigo_orden = o.codigo_orden inner join usuario u 
    on p.comprador_codigo = u.id inner join venta_exitosa ve 
    on ve.id_venta_exitosa = v.id_venta
    where v.vendedor_codigo = '${codigo}' and v.estado = 'Exitosa'
    group by v.id_venta,u.nombre,ve.fecha_venta,u.img,o.codigo_orden ;`)
    .then(data => {
        res.status(200).json(data)
    })
    .then(err => {
        console.log(err)
    })

}

const getOngoingSalePreview = async (req,res) => {
    const codigo = req.query.codigo

    await db.connection.any(`select v.id_venta,u.nombre,vp.fecha_pedido,
    sum(p.cantidad_bateria) as total,u.img,o.codigo_orden from venta v inner join ventaxorden v2 
    on v.id_venta = v2.id_venta inner join orden o 
    on o.codigo_orden = v2.codigo_orden inner join pedido p 
    on p.codigo_orden = o.codigo_orden inner join usuario u 
    on p.comprador_codigo = u.id inner join venta_pendiente vp 
    on vp.id_venta_pendiente = v.id_venta
    where v.vendedor_codigo = '${codigo}' and v.estado = 'Pendiente'
    group by v.id_venta,u.nombre,vp.fecha_pedido,u.img,o.codigo_orden`)
    .then(data => {
        res.status(200).json(data)
    })
    .then(err => {
        console.log(err)
    })

}

module.exports = {getSuccessfulSalePreview,getOngoingSalePreview}