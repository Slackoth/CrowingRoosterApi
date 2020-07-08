const db = require('../db/connection')

const getSpecific = async (req,res) => {
    const codigo = req.query.codigo

    const product = await db.connection.any(`select *from bateria b where b.id_bateria ='${codigo}';`)
    .then(data => {
        return res.status(200).json(data)
    })
    .catch(err => {
        console.log(err)
    })
}

const getall= async(req, res)=>{
    const product = await db.connection.any(`select *from bateria`)
    .then(data => {
        return res.status(200).json(data)
    })
    .catch(err => {
        console.log(err)
    })
}

module.exports = {getSpecific, getall}