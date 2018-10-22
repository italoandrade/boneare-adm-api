describe('[Mocha]: Testing Boneare Adm API', async () => {
    require('../server')();

    global.scope = {};

    require('../api/core/ping/ping.test');
    require('../api/core/user/user.test');
    require('../api/core/client/client.test');
    require('../api/core/product/product.test');
    require('../api/core/order/order.test');
});