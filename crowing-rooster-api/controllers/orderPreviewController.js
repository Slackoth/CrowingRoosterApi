var db = require('../db/connection')

const getSuccessfulOrderPreview = async (req,res) => {
    const code = req.query.codigo

    db.connection.any(`select o.codigo_orden, oe.fecha_entrega, 
    sum(p.cantidad_bateria) as cantidad, o.estado
    from orden o inner join orden_exitosa oe 
    on o.codigo_orden = oe.id_oexitosa inner join pedido p 
    on o.codigo_orden = p.codigo_orden inner join comprador c2 
    on p.comprador_codigo = c2.codigo 
    where c2.codigo = '${code}' and o.estado = 'Exitosa'
    group by o.codigo_orden, oe.fecha_entrega;`
    )
    .then(data => {
        res.status(200).json(data)
    })
    .then(err => {
        console.log(err)
    })
}

module.exports = {getSuccessfulOrderPreview}