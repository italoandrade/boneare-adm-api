const db = global.db;

module.exports = {
    findAll,
    findById,
    findAutocomplete,
    add,
    update,
    remove
};

async function findAll(params) {
    return await db.func('BoneareAdm.ProductFindAll', [
        params.filter,
        params.sortColumn,
        params.sortOrder,
        params.pageNumber,
        params.pageSize
    ]);
}

async function findAutocomplete(params) {
    return await db.func('BoneareAdm.ProductFindAutocomplete', [
        params.filter,
        params.unless
    ]);
}

async function findById(params) {
    return (await db.func('BoneareAdm.ProductFindById', [
        params.id
    ]))[0];
}

async function add(params) {
    return await db.json('BoneareAdm.ProductAdd', [
        params.userIdAction,
        params.name,
        params.weight,
        params.price
    ]);
}

async function update(params) {
    return await db.json('BoneareAdm.ProductUpdate', [
        params.userIdAction,
        params.id,
        params.name,
        params.weight,
        params.price
    ]);
}

async function remove(params) {
    return await db.json('BoneareAdm.ProductRemove', [
        params.id
    ]);
}