var db = require('../db/connection')

const getSuccessfulSaleDetails = async (req,res) => {
    const codigo = req.query.codigo
    const orderId = req.query.ordenId

    const seller = await db.connection.any(`select v.vendedor_codigo,
    u.nombre,c.email,e.nombre_empresa,ve.precio,mp.metodo,ve.fecha_venta as fecha,
    sum(p.cantidad_bateria ) as cantidad_total,
    jsonb_agg(json_build_object(
        'estado', v.estado , 
        'comprador', p.comprador_codigo ,
        'cantidad',p.cantidad_bateria,
        'modelo',b.modelo,
        'calidad',c2.tipo ,
        'polaridad',p2.direccion 
    )) as pedidos
    from venta v inner join ventaxorden v2
    on v.id_venta = v2.id_venta inner join orden o 
    on o.codigo_orden = v2.codigo_orden inner join pedido p 
    on p.codigo_orden = o.codigo_orden inner join usuario u 
    on p.comprador_codigo = u.id inner join comprador c 
    on c.codigo = p.comprador_codigo inner join empresa e 
    on c.id_empresa = e.id_empresa inner join venta_exitosa ve 
    on ve.id_venta_exitosa = v.id_venta inner join metodo_pago mp 
    on mp.id_metodo_pago = ve.metodo_pago inner join bateria b 
    on b.id_bateria = p.id_bateria inner join calidad c2 
    on c2.id_calidad = b.calidad inner join polaridad p2 
    on p2.id_polaridad = b.polaridad
    where v.vendedor_codigo = '${codigo}' and o.codigo_orden = '${orderId}'
    group by v.vendedor_codigo,u.nombre,c.email,e.nombre_empresa,
    ve.precio,mp.metodo,ve.fecha_venta;
    `)
    .then(data => {
        return res.status(200).json(data)
    })
    .catch(err => {
        console.log(err)
    })
}

const getOngoingSaleDetails = async (req,res) => {
    const codigo = req.query.codigo
    const orderId = req.query.ordenId

    const seller = await db.connection.any(`select v.vendedor_codigo,
    u.nombre,c.email,e.nombre_empresa,'' as precio,'' as metodo,
    vp.fecha_pedido as fecha,
    sum(p.cantidad_bateria ) as cantidad_total,
    jsonb_agg(json_build_object(
        'estado', v.estado , 
        'comprador', p.comprador_codigo ,
        'cantidad',p.cantidad_bateria,
        'modelo',b.modelo,
        'calidad',c2.tipo ,
        'polaridad',p2.direccion 
    )) as pedidos
    from venta v inner join ventaxorden v2
    on v.id_venta = v2.id_venta inner join orden o 
    on o.codigo_orden = v2.codigo_orden inner join pedido p 
    on p.codigo_orden = o.codigo_orden inner join usuario u 
    on p.comprador_codigo = u.id inner join comprador c 
    on c.codigo = p.comprador_codigo inner join empresa e 
    on c.id_empresa = e.id_empresa inner join venta_pendiente vp 
    on vp.id_venta_pendiente = v.id_venta inner join bateria b 
    on b.id_bateria = p.id_bateria inner join calidad c2 
    on c2.id_calidad = b.calidad inner join polaridad p2 
    on p2.id_polaridad = b.polaridad
    where v.vendedor_codigo = '${codigo}' and o.codigo_orden = '${orderId}'
    group by v.vendedor_codigo,u.nombre,c.email,e.nombre_empresa,vp.fecha_pedido ;`)
    .then(data => {
        return res.status(200).json(data)
    })
    .catch(err => {
        console.log(err)
    })
}

module.exports = {getSuccessfulSaleDetails,getOngoingSaleDetails}