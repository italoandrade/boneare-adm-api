const asyncMiddleware = require('./utils/asyncMiddleware');

module.exports = app => {
    const functionalities = {
        ping: require('./core/ping/ping.routes'),
        user: require('./core/user/user.routes')
    };

    for (const functionalityKey in functionalities) {
        for (const methodKey in functionalities[functionalityKey]) {
            if (functionalities[functionalityKey].hasOwnProperty(methodKey)) {
                const route = functionalities[functionalityKey][methodKey];
                app[route.type](route.path, asyncMiddleware(route.method))
            }
        }
    }

    app.get('/api', asyncMiddleware((req, res) => {
        res.send(functionalities)
    }))
};