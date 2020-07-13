var db = require('../db/connection')
const e = require('express')

const CreateOrder = async (req,res) => {
    //const email = req.query.email

    const orden = await db.connection.any(
     `
     begin;
     set constraints fk_orden_pendiente deferred;
     
     
     insert into orden_pendiente values (generar_nuevo_codigo('O'),CURRENT_DATE);
     insert into orden values(generar_nuevo_codigo('O'),'Pendiente') returning  orden.codigo_orden as codigo;
     commit;

     `)
    .then(data =>{
        console.log(data)
        return res.status(200).send(data)
    })
    .catch(err=>{
        console.log(err)
    })
}

const getCode= async (req, res)=>{
    const code = await db.connection.any(`
    select o.codigo_orden as codigoOrden, o.estado from orden o 
    order by o.codigo_orden desc
    limit 1
    `)
    .then(data =>{
        console.log(data)
        return res.status(200).send(data)
    })
    .catch(err=>{
        console.log(err)
    })
}

module.exports = {getCode, CreateOrder}