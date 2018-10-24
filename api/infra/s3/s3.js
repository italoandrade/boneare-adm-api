const
    S3FS = require('s3fs'),
    config = require('../../config');

const
    s3Options = {
        region: config.s3.region,
        accessKeyId: config.s3.accessKeyId,
        secretAccessKey: config.s3.secretAccessKey
    },
    fsImpl = new S3FS(config.s3.bucket, s3Options);

console.log('[S3Bucket]: Initialized');

module.exports = fsImpl;