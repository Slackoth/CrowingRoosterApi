var db = require('../db/connection')

const getSuccessfulOrderPreview = async (req,res) => {
    const code = req.query.codigo

    await db.connection.any(`select o.codigo_orden, op.fecha_pendiente, sum(p.cantidad_bateria) as cantidad,
    o.estado,c2.codigo as comprador,b2.product_img as img
    from orden o inner join orden_pendiente op 
    on o.codigo_orden = op.id_opendiente inner join pedido p 
    on o.codigo_orden = p.codigo_orden inner join comprador c2 
    on p.comprador_codigo = c2.codigo inner join bateria b2 
    on p.id_bateria = b2.id_bateria 
    where c2.codigo = '${code}' and o.estado = 'Exitosa'
    group by o.codigo_orden, op.fecha_pendiente,c2.codigo,b2.product_img ;`
    )
    .then(data => {
        res.status(200).json(data)
    })
    .then(err => {
        console.log(err)
    })
}

const getOngoingOrderPreview = async (req,res) => {
    const code = req.query.codigo

    console.log(code);
    

    await db.connection.any(`select o.codigo_orden, op.fecha_pendiente, sum(p.cantidad_bateria) as cantidad,
    o.estado,c2.codigo as comprador,b2.product_img as img
    from orden o inner join orden_pendiente op 
    on o.codigo_orden = op.id_opendiente inner join pedido p 
    on o.codigo_orden = p.codigo_orden inner join comprador c2 
    on p.comprador_codigo = c2.codigo inner join bateria b2 
    on p.id_bateria = b2.id_bateria 
    where c2.codigo = '${code}' and o.estado = 'Pendiente'
    group by o.codigo_orden, op.fecha_pendiente,c2.codigo,b2.product_img ;`
    )
    .then(data => {
        res.status(200).json(data)
    })
    .then(err => {
        console.log(err)
    })
}

module.exports = {getSuccessfulOrderPreview,getOngoingOrderPreview}