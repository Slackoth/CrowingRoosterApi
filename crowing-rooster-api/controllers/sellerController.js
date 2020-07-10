const db = require('../db/connection')

const getSpecific = async (req,res) => {
    const codigo = req.query.codigo

    const seller = await db.connection.any(`select v.codigo,u.nombre,
    v.email,u.img,t.telefono from 
    vendedor v inner join usuario u 
    on v.codigo = u.id inner join telefono t 
    on v.codigo = t.vendedor_codigo 
    where v.codigo = '${codigo}'`)
    .then(data => {
        return res.status(200).json(data)
    })
    .catch(err => {
        console.log(err)
    })
}

const getFree= async( req, res )=>{
    const seller= await db.connection.any(`select v.email ,count (codigo) as cant from vendedor v left join usuario u on u.id = v.codigo 
    left join venta v2 on v2.vendedor_codigo = v.codigo 
    left join venta_pendiente v3 on v3.id_venta_pendiente = v2.id_venta 
    group by v.email 
    order by cant desc 
    limit 1
    `)
    .then(data=>{
        return res.status(200).json(data)
    })
    .catch(err=>{
        console.log(err)
    })
}

module.exports = {getSpecific, getFree}