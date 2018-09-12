module.exports = {
    signIn
};

async function signIn(user) {
    const userInfo = {
        user: {
            name: 'Ítalo Andrade',
            email: user.email
        },
        token: 'TOKENTEST'
    };

    if (userInfo.token) {
        if (userInfo.token === 'TOKENTEST') {
            return userInfo;
        } else {
            throw {httpCode: 403, message: 'Token inválido', code: 3}
        }
    } else {
        if (user.email === 'test@test.com') {
            if (user.password === 'test') {
                return userInfo;
            } else {
                throw {httpCode: 403, message: 'Senha incorreta', code: 2}
            }
        } else {
            throw {httpCode: 403, message: 'Usuário não encontrado', code: 1}
        }
    }
}