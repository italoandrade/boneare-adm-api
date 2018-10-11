const db = global.db;

module.exports = {
    findAll,
    findById: require('./order.mock').findById,
    add: require('./order.mock').add,
    update: require('./order.mock').update,
    remove: require('./order.mock').remove
};

async function findAll(params) {
    return await db.func('BoneareAdm.OrderFindAll', [
        params.filter,
        params.sortColumn,
        params.sortOrder,
        params.pageNumber,
        params.pageSize
    ]);
}