const
    service = require('./product.service');

module.exports = {
    findAll,
    findById,
    findAutocomplete,
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

async function findAutocomplete(req, res) {
    const params = {
        filter: req.body.filter,
        unless: req.body.unless
    };

    const data = await service.findAutocomplete(params);

    res.finish(data)
}

async function add(req, res) {
    const params = {
        userIdAction: req.user.id,
        name: req.body.name,
        weight: req.body.weight,
        price: req.body.price
    };

    const data = await service.add(params);

    res.finish({
        code: 0,
        message: 'Produto adicionado',
        return: data
    })
}

async function update(req, res) {
    const params = {
        userIdAction: req.user.id,
        id: req.params.id,
        name: req.body.name,
        weight: req.body.weight,
        price: req.body.price
    };

    await service.update(params);

    res.finish({
        code: 0,
        message: 'Produto atualizado'
    })
}

async function remove(req, res) {
    const params = {
        id: req.params.id
    };

    await service.remove(params);

    res.finish({
        code: 0,
        message: 'Produto excluído'
    })
}