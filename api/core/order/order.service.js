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
    const data = await repository.add(params);
    switch (data.code) {
        case 1:
            throw {httpCode: 409, ...data};
    }
    return data.return;
}

async function update(params) {
    const data = await repository.update(params);
    switch (data.code) {
        case 1:
            throw {httpCode: 404, ...data};
        case 2:
            throw {httpCode: 409, ...data};
    }
}

async function remove(params) {
    const data = await repository.remove(params);
    switch (data.code) {
        case 1:
            throw {httpCode: 404, ...data};
        case 2:
            throw {httpCode: 409, ...data};
    }
}