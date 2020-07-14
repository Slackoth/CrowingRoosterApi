const promise = require('bluebird')
const options = {
    promiseLib: promise
}

const pgp = require('pg-promise')(options)
//postgres://username:password@host:port/databasename
const connectionString = `postgres://${process.env.USER_DB}:${process.env.PASS_DB}@${process.env.HOST}:${process.env.PORT_DB}/${process.env.DB}`
//process.env.DATABASE_URL || 
const connection = pgp(connectionString)

module.exports = {connection}