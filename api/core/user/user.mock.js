module.exports = {
    signIn
};

async function signIn(user) {
    if (user.email === 'test@test.com') {
        if (user.password === 'test') {
            return {
                user: {
                    name: 'Ítalo Andrade',
                    email: user.email
                },
                token: 'TOKENTEST'
            }
        } else {
            throw {httpCode: 403, message: 'Senha incorreta'}
        }
    } else {
        throw {httpCode: 403, message: 'Usuário não encontrado'}
    }
}