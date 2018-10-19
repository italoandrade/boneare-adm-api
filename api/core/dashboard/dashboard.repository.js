const db = global.db;

module.exports = {
    getInfo
};

async function getInfo() {
    return (await db.func('BoneareAdm.DashboardGetInfo'))[0];
}