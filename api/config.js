const config = {
    env: process.env.NODE_ENV,
    clusterCount: process.env.CLUSTER_COUNT || require('os').cpus().length,
    host: process.env.HOST || 'localhost',
    port: process.env.PORT || 3000,
    url: undefined,
};

config.url = `http://${config.host}${config.port ? ':' + config.port : ''}`;

module.exports = config;
