const
    express = require('express'),
    bodyParser = require('body-parser'),
    cors = require('cors'),
    app = express(),
    config = require('./api/config'),
    log = require('./api/utils/log');

module.exports = async () => {
    app.use(bodyParser.json());
    app.use(cors());

    app.use(log.init);

    require('./api/routes')(app);

    app.use(log.save);

    await app.listen(config.port, () => console.log(`[Server]: Running and listening on port ${config.port}`))
};