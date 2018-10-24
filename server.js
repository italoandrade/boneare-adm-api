const
    express = require('express'),
    bodyParser = require('body-parser'),
    cors = require('cors'),
    app = express(),
    config = require('./api/config'),
    log = require('./api/utils/logHelper');

module.exports = async () => {
    global.db = require('./api/infra/db/db');
    global.s3 = require('./api/infra/s3/s3');

    app.use(bodyParser.json({limit: '10mb'}));
    app.use(cors({
        methods: ['GET', 'POST', 'PUT', 'DELETE'],
        allowedHeaders: ['Content-Type', 'Authorization']
    }));

    app.use(log.init);

    require('./api/routes')(app);

    app.use(log.save);

    await app.listen(config.port, () => console.log(`[Server]: Running and listening on port ${config.port}`))
};