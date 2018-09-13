const
    tokenHelper = require('../../utils/tokenHelper'),
    colorHelper = require('../../utils/colorHelper'),
    config = require('../../config'),
    repository = !config.mock ? require('./user.repository') : require('./user.mock');

module.exports = {
    signIn
};

async function signIn(params) {
    let user;
    let token;

    if (!params.token) {
        user = await repository.signIn(params);
        if (user) {
            if (user.correctPassword) {
                user.color = colorHelper(user.color);
                token = await tokenHelper.create({
                    id: user.id
                });
            } else {
                throw {code: 2, message: 'Senha incorreta'};
            }
        } else {
            throw {code: 1, message: 'Usuário não encontrado'};
        }
    } else {
        let tokenRead;
        try {
            tokenRead = await tokenHelper.read(params.token);
        } catch (e) {
            throw {code: 3, message: 'Token inválido'}
        }

        user = await repository.signIn({id: tokenRead.id});
        user.color = colorHelper(user.color);
        token = await tokenHelper.create({
            id: user.id
        });
    }

    delete user.correctPassword;
    delete user.id;

    return {
        user,
        token
    };
}
