var db = require('../db/connection')

const getSuccessfulDeliveryPreview = async (req,res) => {
    const codigo = req.query.codigo

    await db.connection.any(`select e.id_entrega, vtee.direccion_entrega, ee.estado, vte.precio, mp.metodo, b.product_img, rxe.codigo_repartidor
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
    on pd.id_bateria = b.id_bateria
    where rxe.codigo_repartidor = '${codigo}' and ee.estado = 'Exitosa'
    group by e.id_entrega, vtee.direccion_entrega, ee.estado, vte.precio, mp.metodo, b.product_img, rxe.codigo_repartidor;`)
    .then(data => {
        res.status(200).json(data)
    })
    .then(err => {
        console.log(err)
    })
}

const getOngoingDeliveryPreview = async (req, res) => {
    const codigo = req.query.codigo

    await db.connection.any(`select e.id_entrega, vtee.direccion_entrega, ee.estado, vte.precio, mp.metodo, b.product_img, rxe.codigo_repartidor
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
    on pd.id_bateria = b.id_bateria
    where rxe.codigo_repartidor = '${codigo}' and ee.estado = 'Pendiente'
    group by e.id_entrega, vtee.direccion_entrega, ee.estado, vte.precio, mp.metodo, b.product_img, rxe.codigo_repartidor;`)
    .then(data => {
        res.status(200).json(data)
    })
    .then(err => {
        console.log(err)
    })
}

module.exports = {getSuccessfulDeliveryPreview, getOngoingDeliveryPreview}