const
    service = require('./client.service');

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
        name: req.body.name,
        document: req.body.document,
        description: req.body.description,
        address: req.body.address,
        phones: req.body.phones,
        emails: req.body.emails
    };

    const data = await service.add(params);

    res.finish({
        code: 0,
        message: 'Cliente adicionado',
        returning: data
    })
}

async function update(req, res) {
    const params = {
        id: req.params.id,
        name: req.body.name,
        document: req.body.document,
        description: req.body.description,
        address: req.body.address,
        phones: req.body.phones,
        emails: req.body.emails
    };

    await service.update(params);

    res.finish({
        code: 0,
        message: 'Cliente atualizado'
    })
}

async function remove(req, res) {
    const params = {
        id: req.params.id
    };

    await service.remove(params);

    res.finish({
        code: 0,
        message: 'Cliente excluído'
    })
}