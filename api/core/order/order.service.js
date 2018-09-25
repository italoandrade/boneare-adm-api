const
    config = require('../../config'),
    repository = !config.mock ? require('./order.repository') : require('./order.mock');

module.exports = {
    findAll,
    findById,
    add,
    update,
    remove
};

async function findAll(params) {
    return await repository.findAll(params);
}

async function findById(params) {
    const data = await repository.findById(params);
    if (!data) {
        throw {httpCode: 404, code: 1, message: 'Pedido não encontrado'}
    }
    return data;
}

async function add(params) {
    return await repository.add(params);
}

async function update(params) {
    return await repository.update(params);
}

async function remove(params) {
    return await repository.remove(params);
}