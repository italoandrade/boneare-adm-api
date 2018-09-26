const db = global.db;

module.exports = {
    findAll,
    findById: require('./product.mock').findById,
    findAutocomplete: require('./product.mock').findAutocomplete,
    add: require('./product.mock').add,
    update: require('./product.mock').update,
    remove: require('./product.mock').remove
};

async function findAll(params) {
    return await db.func('BoneareAdm.ClientFindAll', [
        params.filter,
        params.sortColumn,
        params.sortOrder,
        params.pageNumber,
        params.pageSize
    ]);
}