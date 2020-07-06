var db = require('../db/connection')

const getSalePreview = async (req,res) => {
    const codigo = req.query.codigo
    const state = req.query.estado

    await db.connection.any(`select u2.nombre, vp.fecha_pedido, sum(p.cantidad_bateria ) as total, u2.img 
    from venta v inner join orden o 
    on v.vendedor_codigo = o.vendedor_codigo inner join usuario u2 
    on u2.id = o.comprador_codigo inner join pedido p 
    on p.codigo_orden = o.codigo_orden inner join venta_pendiente vp 
    on vp.id_venta_pendiente = v.id_venta 
    where o.vendedor_codigo = '${codigo}' and o.estado = '${state}'
    group by nombre, fecha_pedido , img`)
    .then(data => {
        res.status(200).json(data)
    })
    .then(err => {
        console.log(err)
    })

}

module.exports = {getSalePreview}