const db = global.db;

module.exports = {
    findAll,
    findById: require('./client.mock').findById,
    add: require('./client.mock').add,
    update: require('./client.mock').update,
    remove: require('./client.mock').remove
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