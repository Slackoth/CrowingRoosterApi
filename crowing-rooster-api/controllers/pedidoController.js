const db = require('../db/connection')


const addPedido= async(req,res)=>{
    const cant = req.body.cantidad_bateria
    const codorden= req.body.codigo_orden
    const id_bateria= req.body.id_bateria


    const add= await db.connection.any(`
    insert into solicitud(equipo,fecha_inicio,fecha_fin,hora_inicio,hora_fin,fecha_solicitud,estado,responsable_carnet,codigo_laboratorio, codigo_materia)
    values($1,$2,$3,$4,$5,'2019-11-24',$6,$7,$8,$9)`,[equipo,inic,fin,hinic,hfin,estado,carnet,labo,mat])
    .then(data=>{
        res.redirect('/calendar')
    })
    .catch(err=>{
        console.log(err);
        return res.status(400).json(err)
    })

}


modulee.exports={addPedido}