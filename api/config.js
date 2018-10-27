const config = {
    env: process.env.NODE_ENV || 'dev',
    debug: process.env.DEBUG === 'true',
    mock: process.env.MOCK === 'true',
    clusterCount: process.env.CLUSTER_COUNT || require('os').cpus().length,
    host: process.env.HOST || 'localhost',
    port: process.env.PORT || 3100,
    url: undefined,
    db: {
        host: process.env.PGHOST || 'localhost',
        port: process.env.PGPORT || 5432,
        database: process.env.PGDATABASE || 'boneareadm',
        user: process.env.PGUSER || 'italo',
        password: process.env.PGPASSWORD || '123',
    },
    hash: process.env.HASH || 'xirofompila',
    s3: {
        region: process.env.S3REGION || 'us-east-1',
        bucket: process.env.S3BUCKET || 'boneareadm-dev',
        accessKeyId: process.env.S3ACCESSKEYID,
        secretAccessKey: process.env.S3SECRETACCESSKEY
    }
};
config.url = `http://${config.host}${config.port ? ':' + config.port : ''}`;
config.s3.url = 'https://s3.amazonaws.com/' + config.s3.bucket;

module.exports = config;
