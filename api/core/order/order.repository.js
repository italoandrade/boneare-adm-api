const db = global.db;

module.exports = {
    findAll,
    findById,
    add,
    update,
    remove
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

async function findById(params) {
    return (await db.func('BoneareAdm.OrderFindById', [
        params.id
    ]))[0];
}

async function add(params) {
    return await db.json('BoneareAdm.OrderAdd', [
        params.userIdAction,
        params.name,
        params.client,
        JSON.stringify(params.products),
        JSON.stringify(params.transactions)
    ]);
}

async function update(params) {
    return await db.json('BoneareAdm.OrderUpdate', [
        params.userIdAction,
        params.id,
        params.name,
        params.client,
        JSON.stringify(params.products),
        JSON.stringify(params.transactions)
    ]);
}

async function remove(params) {
    return await db.json('BoneareAdm.OrderRemove', [
        params.id
    ]);
}