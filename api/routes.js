const asyncMiddleware = require('./utils/asyncMiddleware');

module.exports = app => {
    const functionalities = {
        ping: require('./core/ping/ping.routes'),
        user: require('./core/user/user.routes'),
        dashboard: require('./core/dashboard/dashboard.routes'),
        client: require('./core/client/client.routes'),
        product: require('./core/product/product.routes'),
        order: require('./core/order/order.routes')
    };

    for (const functionalityKey in functionalities) {
        for (const methodKey in functionalities[functionalityKey]) {
            if (functionalities[functionalityKey].hasOwnProperty(methodKey)) {
                const route = functionalities[functionalityKey][methodKey];
                app[route.type](route.path, asyncMiddleware(route.method, route.public))
            }
        }
    }

    app.get('/api', asyncMiddleware((req, res) => {
        res.send(functionalities)
    }, true))
};