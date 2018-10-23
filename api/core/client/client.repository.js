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
    return await db.func('BoneareAdm.ClientFindAll', [
        params.filter,
        params.sortColumn,
        params.sortOrder,
        params.pageNumber,
        params.pageSize
    ]);
}

async function findAutocomplete(params) {
    return await db.func('BoneareAdm.ClientFindAutocomplete', [
        params.filter,
        params.unless
    ]);
}

async function findById(params) {
    return (await db.func('BoneareAdm.ClientFindById', [
        params.id
    ]))[0];
}

async function add(params) {
    return await db.json('BoneareAdm.ClientAdd', [
        params.userIdAction,
        params.name,
        params.document,
        params.description,
        params.address,
        JSON.stringify(params.phones),
        JSON.stringify(params.emails)
    ]);
}

async function update(params) {
    return await db.json('BoneareAdm.ClientUpdate', [
        params.userIdAction,
        params.id,
        params.name,
        params.document,
        params.description,
        params.address,
        JSON.stringify(params.phones),
        JSON.stringify(params.emails)
    ]);
}

async function remove(params) {
    return await db.json('BoneareAdm.ClientRemove', [
        params.id
    ]);
}