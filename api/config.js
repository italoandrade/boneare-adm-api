const config = {
    env: process.env.NODE_ENV || 'dev',
    debug: process.env.DEBUG === 'true',
    clusterCount: process.env.CLUSTER_COUNT || require('os').cpus().length,
    host: process.env.HOST || 'localhost',
    port: process.env.PORT || 3000,
    url: undefined,
    db: {
        host: process.env.PGHOST || 'localhost',
        port: process.env.PGPORT || 5432,
        database: process.env.PGDATABASE || 'boneareadm',
        user: process.env.PGUSER || 'italo',
        password: process.env.PGPASSWORD || 'Aspr1ll4**',
    },
    hash: process.env.HASH || 'xirofompila'
};

config.url = `http://${config.host}${config.port ? ':' + config.port : ''}`;

module.exports = config;
