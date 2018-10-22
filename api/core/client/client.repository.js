const db = global.db;

module.exports = {
    findAll,
    findById,
    findAutocomplete: require('./client.mock').findAutocomplete,
    add,
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
        params.description
    ]);
}