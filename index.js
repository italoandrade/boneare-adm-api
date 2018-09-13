const
    config = require('./api/config'),
    cluster = require('cluster'),
    server = require('./server');

if (config.env !== 'dev' && cluster.isMaster) {
    console.log(`[Cluster]: Master ${process.pid} is running`);

    for (let i = 0; i < config.clusterCount; i++) {
        cluster.fork();
    }

    cluster.on('exit', worker => console.error(`[Cluster]: Worker ${worker.process.pid} died`))
} else {
    config.env === 'dev' && console.log('[Server]: Development mode enabled');
    config.debug && console.log('[Server]: Debug mode enabled');
    server()
}