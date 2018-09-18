const
    config = require('../../config'),
    repository = !config.mock ? require('./client.repository') : require('./client.mock');

module.exports = {
    listAll
};

async function listAll(req, res) {
    const params = {
        filter: req.query.filter,
        sortColumn: req.query.sortColumn,
        sortOrder: req.query.sortOrder,
        pageNumber: req.query.pageNumber,
        pageSize: req.query.pageSize
    };

    const data = await repository.listAll(params);

    res.finish(data)
}