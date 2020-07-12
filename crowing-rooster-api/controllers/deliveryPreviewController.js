var db = require('../db/connection')

const getSuccessfulDeliveryPreview = async (req,res) => {
    const codigo = req.query.codigo

    await db.connection.any(`select en.id_entrega, vtxet.direccion_entrega, ent.estado, vex.precio, mp.metodo
    from  estado_entrega ent inner join entrega en
    on ent.id_estado = en.id_estado inner join venta_exitosaxentrega vtxet
    on en.id_entrega = vtxet.id_entrega inner join venta_exitosa vex
    on vtxet.id_venta_exitosa = vex.id_venta_exitosa inner join metodo_pago mp
    on vex.metodo_pago = mp.id_metodo_pago inner join repartidorxentrega rxe
    on en.id_entrega = rxe.id_entrega
    where rxe.codigo_repartidor = '${codigo}' and ent.estado = 'Exitosa'
    group by en.id_entrega, vtxet.direccion_entrega, ent.estado, vex.precio, mp.metodo;`)
    .then(data => {
        res.status(200).json(data)
    })
    .then(err => {
        console.log(err)
    })
}

const getOngoingDeliveryPreview = async (req, res) => {
    const codigo = req.query.codigo

    await db.connection.any(`select en.id_entrega, vtxet.direccion_entrega, ent.estado, vex.precio, mp.metodo
    from  estado_entrega ent inner join entrega en
    on ent.id_estado = en.id_estado inner join venta_exitosaxentrega vtxet
    on en.id_entrega = vtxet.id_entrega inner join venta_exitosa vex
    on vtxet.id_venta_exitosa = vex.id_venta_exitosa inner join metodo_pago mp
    on vex.metodo_pago = mp.id_metodo_pago inner join repartidorxentrega rxe
    on en.id_entrega = rxe.id_entrega
    where rxe.codigo_repartidor = '${codigo}' and ent.estado = 'Pendiente'
    group by en.id_entrega, vtxet.direccion_entrega, ent.estado, vex.precio, mp.metodo;`)
    .then(data => {
        res.status(200).json(data)
    })
    .then(err => {
        console.log(err)
    })
}

module.exports = {getSuccessfulDeliveryPreview, getOngoingDeliveryPreview}