const config = require('../../config');

const initOptions = {};

const pgp = require('pg-promise')(initOptions);

const db = pgp({
    host: config.db.host,
    port: config.db.port,
    database: config.db.database,
    user: config.db.user,
    password: config.db.password
});

db.connect()
    .then(obj => {
        console.log('[Database]: Connected');
        obj.done();
    })
    .catch(error => {
        console.log('[Database]: Could not connect');
        console.error(error);
    });

module.exports = db;