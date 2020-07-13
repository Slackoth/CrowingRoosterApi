var db = require('../db/connection')

const getSuccessfulDeliveryDetails = async (req,res) => {
    const codigo = req.query.codigo
    const idEntrega = req.query.idEntrega

    const delivery = await db.connection.any(`select rxe.codigo_repartidor ,e.id_entrega, vtee.direccion_entrega,
    vte.precio, mp.metodo, sum(pd.cantidad_bateria) as cantidad_total, ee.estado,
	jsonb_agg(json_build_object(
        'estado', ee.estado,
        'comprador', pd.comprador_codigo,
        'cantidad', pd.cantidad_bateria,
		'modelo', b.modelo,
		'dimensiones', b.dimensiones,
		'calidad', cl.tipo,
        'polaridad', pl.direccion,
        'id_entrega', e.id_entrega,
        'id_pedido', pd.numero_pedido
	)) as pedidos
    from repartidorxentrega rxe inner join entrega e
    on rxe.id_entrega = e.id_entrega inner join estado_entrega ee
    on e.id_estado = ee.id_estado inner join venta_exitosaxentrega vtee
    on e.id_entrega = vtee.id_entrega inner join venta_exitosa vte
    on vtee.id_venta_exitosa = vte.id_venta_exitosa inner join metodo_pago mp
    on vte.metodo_pago = mp.id_metodo_pago inner join venta vt
    on vte.id_venta_exitosa = vt.id_venta inner join ventaxorden vtxo
    on vt.id_venta = vtxo.id_venta_ventaxorden inner join orden o
    on vtxo.id_orden_ventaxorden = o.codigo_orden inner join pedido pd
    on o.codigo_orden = pd.codigo_orden inner join bateria b
    on pd.id_bateria = b.id_bateria inner join calidad cl
	on b.calidad = cl.id_calidad inner join polaridad pl
	on b.polaridad = pl.id_polaridad
    where rxe.codigo_repartidor = '${codigo}' and e.id_entrega = ${idEntrega} and ee.estado = 'Exitosa'
    group by e.id_entrega, vtee.direccion_entrega, ee.estado, vte.precio, mp.metodo, rxe.codigo_repartidor;`)
    .then(data => {
        return res.status(200).json(data)
    })
    .catch(err => {
        console.log(err)
    })
}

const getOngoingDeliveryDetails = async (req,res) => {
    const codigo = req.query.codigo
    const idEntrega = req.query.idEntrega

    const delivery = await db.connection.any(`select rxe.codigo_repartidor ,e.id_entrega, vtee.direccion_entrega,
    vte.precio, mp.metodo, sum(pd.cantidad_bateria) as cantidad_total, ee.estado,
	jsonb_agg(json_build_object(
        'estado', ee.estado,
        'comprador', pd.comprador_codigo,
        'cantidad', pd.cantidad_bateria,
		'modelo', b.modelo,
		'dimensiones', b.dimensiones,
		'calidad', cl.tipo,
        'polaridad', pl.direccion,
        'id_entrega', e.id_entrega,
        'id_pedido', pd.numero_pedido
	)) as pedidos
    from repartidorxentrega rxe inner join entrega e
    on rxe.id_entrega = e.id_entrega inner join estado_entrega ee
    on e.id_estado = ee.id_estado inner join venta_exitosaxentrega vtee
    on e.id_entrega = vtee.id_entrega inner join venta_exitosa vte
    on vtee.id_venta_exitosa = vte.id_venta_exitosa inner join metodo_pago mp
    on vte.metodo_pago = mp.id_metodo_pago inner join venta vt
    on vte.id_venta_exitosa = vt.id_venta inner join ventaxorden vtxo
    on vt.id_venta = vtxo.id_venta_ventaxorden inner join orden o
    on vtxo.id_orden_ventaxorden = o.codigo_orden inner join pedido pd
    on o.codigo_orden = pd.codigo_orden inner join bateria b
    on pd.id_bateria = b.id_bateria inner join calidad cl
	on b.calidad = cl.id_calidad inner join polaridad pl
	on b.polaridad = pl.id_polaridad
    where rxe.codigo_repartidor = '${codigo}' and e.id_entrega = ${idEntrega} and ee.estado = 'Pendiente'
    group by e.id_entrega, vtee.direccion_entrega, ee.estado, vte.precio, mp.metodo, rxe.codigo_repartidor;`)
    .then(data => {
        return res.status(200).json(data)
    })
    .catch(err => {
        console.log(err)
    })
}


module.exports = {getSuccessfulDeliveryDetails, getOngoingDeliveryDetails}