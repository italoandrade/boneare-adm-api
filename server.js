const
    express = require('express'),
    bodyParser = require('body-parser'),
    cors = require('cors'),
    app = express(),
    config = require('./api/config'),
    log = require('./api/utils/logHelper'),
    db = require('./api/infra/db/db');

module.exports = async () => {
    global.db = db;

    app.use(bodyParser.json());
    app.use(cors({
        methods: ['GET', 'POST', 'PUT'],
        allowedHeaders: ['Content-Type', 'Authentication']
    }));

    app.use(log.init);

    require('./api/routes')(app);

    app.use(log.save);

    await app.listen(config.port, () => console.log(`[Server]: Running and listening on port ${config.port}`))
};