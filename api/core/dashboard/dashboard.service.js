const
    config = require('../../config'),
    repository = !config.mock ? require('./dashboard.repository') : require('./dashboard.mock');

module.exports = {
    getInfo
};

async function getInfo(params) {
    const data = await repository.getInfo(params);
    data.balance = +data.balance;
    data.clients = +data.clients;
    data.stock = +data.stock;
    return data;
}
