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

if (!config.mock) {
    db.connect()
        .then(obj => {
            console.log('[Database]: Connected');
            obj.done();
        })
        .catch(error => {
            console.error('[Database]: Could not connect', error);
        });
} else {
    console.log('[Server]: Mock mode enabled');
}

module.exports = {
    json: async function (query, params) {
        let result = await db.proc(query, params);

        return result ? result[Object.keys(result)[0]] : null;
    },
    func: db.func
};