describe('[Mocha]: Testing Boneare Adm API', async () => {
    require('../server')();

    require('../api/core/ping/ping.test');
    require('../api/core/user/user.test');
});