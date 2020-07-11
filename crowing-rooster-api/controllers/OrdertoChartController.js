var db = require('../db/connection')
const e = require('express')

const postOrder = async (req,res) => {
    //const email = req.query.email

    const add = await db.connection.any(`
    begin;
    set constraints fk_comprador_codigo deferred;
    set constraints fk_vendedor_codigo deferred;
    set constraints fk_orden_pendiente deferred;
    
    insert into orden_pendiente values (generar_nuevo_codigo('O'), current_date);
    insert into orden values(generar_nuevo_codigo('O'), 'Pendiente');
    commit;
    `)
    .then(data =>{
        return res.status(200).send(data)
    })
    .catch(err=>{
        console.log(err)
    })
}

module.exports = {postOrder}