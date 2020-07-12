const db = require('../db/connection')

const getall= async(req, res)=>{
    const product = await db.connection.any(`select b.id_bateria, b.modelo, b.dimensiones ,p.direccion ,b.capacidad_reserva, c.tipo , b.amperaje , b.cca, b.product_img from bateria b left join calidad c on b.calidad= c.id_calidad left join polaridad p on p.id_polaridad =b.polaridad;`)
    .then(data => {
        return res.status(200).json(data)
    })
    .catch(err => {
        console.log(err)
    })
}

module.exports = {getall}