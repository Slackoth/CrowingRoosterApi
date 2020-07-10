var db = require('../db/connection')

const getSuccessfulOrderDetails = async (req,res) => {
    const code = req.query.codigo
    const orderId = req.query.ordenId

    await db.connection.any(`select c2.codigo,u2.nombre,v3.email,
    oe.fecha_entrega as fecha, oe.precio_total as precio,
    mp.metodo,sum(p.cantidad_bateria) as total,t2.telefono,
    jsonb_agg(json_build_object(
        'estado', o.estado, 
        'cantidad',p.cantidad_bateria,
        'modelo',b.modelo,
        'calidad',c3.tipo ,
        'polaridad',p2.direccion,
        'id_orden',o.codigo_orden ,
        'id_pedido',p.numero_pedido
    )) as pedidos
    from venta v inner join ventaxorden v2 
    on v2.id_venta = v.id_venta inner join orden o 
    on o.codigo_orden = v2.codigo_orden inner join pedido p 
    on p.codigo_orden = o.codigo_orden inner join comprador c2 
    on p.comprador_codigo = c2.codigo inner join vendedor v3 
    on v.vendedor_codigo = v3.codigo inner join usuario u2 
    on u2.id = v.vendedor_codigo inner join orden_exitosa oe 
    on oe.id_oexitosa = o.codigo_orden inner join metodo_pago mp 
    on mp.id_metodo_pago = oe.metodo_pago inner join telefono t2 
    on t2.vendedor_codigo = v3.codigo inner join bateria b 
    on b.id_bateria = p.id_bateria inner join calidad c3 
    on c3.id_calidad = b.calidad inner join polaridad p2 
    on p2.id_polaridad = b.polaridad 
    where c2.codigo = '${code}' and o.codigo_orden = '${orderId}'
    group by v3.codigo,u2.nombre,v3.email,oe.fecha_entrega, oe.precio_total,
    mp.metodo,t2.telefono,c2.codigo;
    `)
    .then(data => {
        res.status(200).json(data)
    })
    .then(err => {
        console.log(err)
    })
}

const getOngoingOrderDetails = async (req,res) => {
    const code = req.query.codigo
    const orderId = req.query.ordenId

    await db.connection.any(`select  c2.codigo,u2.nombre,v3.email,op.fecha_pendiente as fecha, '' as precio,
    '' as metodo,sum(p.cantidad_bateria) as total,t2.telefono,
    jsonb_agg(json_build_object(
        'estado', o.estado, 
        'cantidad',p.cantidad_bateria,
        'modelo',b.modelo,
        'calidad',c3.tipo ,
        'polaridad',p2.direccion,
        'id_orden',o.codigo_orden ,
        'id_pedido',p.numero_pedido
    )) as pedidos
    from venta v inner join ventaxorden v2 
    on v2.id_venta = v.id_venta inner join orden o 
    on o.codigo_orden = v2.codigo_orden inner join pedido p 
    on p.codigo_orden = o.codigo_orden inner join comprador c2 
    on p.comprador_codigo = c2.codigo inner join vendedor v3 
    on v.vendedor_codigo = v3.codigo inner join usuario u2 
    on u2.id = v.vendedor_codigo inner join orden_pendiente op 
    on op.id_opendiente = o.codigo_orden inner join telefono t2 
    on t2.vendedor_codigo = v3.codigo inner join bateria b 
    on b.id_bateria = p.id_bateria inner join calidad c3 
    on c3.id_calidad = b.calidad inner join polaridad p2 
    on p2.id_polaridad = b.polaridad 
    where c2.codigo = '${code}' and o.codigo_orden = '${orderId}'
    group by v3.codigo,u2.nombre,v3.email,op.fecha_pendiente,t2.telefono,c2.codigo ;`
    )
    .then(data => {
        res.status(200).json(data)
    })
    .then(err => {
        console.log(err)
    })
}

module.exports = {getSuccessfulOrderDetails,getOngoingOrderDetails}