const db = global.db;

module.exports = {
    listAll
};

async function listAll(params) {
    return await db.func('BoneareAdm.ClientListAll', [
        params.filter,
        params.sortColumn,
        params.sortOrder,
        params.pageNumber,
        params.pageSize
    ]);
}