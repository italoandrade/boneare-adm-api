const db = global.db;

module.exports = {
    signIn
};

async function signIn(params) {
    return (await db.func('BoneareAdm.UserSignIn', [
        params.id,
        params.email,
        params.password
    ]))[0];
}