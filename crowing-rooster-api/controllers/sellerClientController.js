const db = require('../db/connection')

const getAllClients = async (req,res) => {
    const clients = await db.connection.any(``)
    .then(data => {
        return res.status(200).json(data)
    })
    .catch(err => {
        console.log(err)
    })
}