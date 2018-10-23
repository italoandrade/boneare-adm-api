const
    service = require('./order.service');

module.exports = {
    findAll,
    findById,
    add,
    update,
    remove
};

async function findAll(req, res) {
    const params = {
        filter: req.query.filter,
        sortColumn: req.query.sortColumn,
        sortOrder: req.query.sortOrder,
        pageNumber: req.query.pageNumber,
        pageSize: req.query.pageSize
    };

    const data = await service.findAll(params);

    res.finish(data)
}

async function findById(req, res) {
    const params = {
        id: req.params.id
    };

    const data = await service.findById(params);

    res.finish(data)
}

async function add(req, res) {
    const params = {
        userIdAction: req.user.id,
        description: req.body.description,
        client: req.body.client,
        products: req.body.products,
        transactions: req.body.transactions
    };

    const data = await service.add(params);

    res.finish({
        code: 0,
        message: 'Pedido adicionado',
        return: data
    })
}

async function update(req, res) {
    const params = {
        userIdAction: req.user.id,
        id: req.params.id,
        description: req.body.description,
        client: req.body.client,
        products: req.body.products,
        transactions: req.body.transactions
    };

    await service.update(params);

    res.finish({
        code: 0,
        message: 'Pedido atualizado'
    })
}

async function remove(req, res) {
    const params = {
        id: req.params.id
    };

    await service.remove(params);

    res.finish({
        code: 0,
        message: 'Pedido excluído'
    })
}