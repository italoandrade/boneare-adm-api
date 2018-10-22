const config = require('../config');
const tokenHelper = require('./tokenHelper');

const defaultMessages = {
    404: 'Recurso não foi encontrado',
    409: 'Operação conflitante',
    500: 'Ocorreu um erro interno'
};

module.exports = (fn, isPublic) =>
    (req, res, next) => {
        Promise.resolve(auth(fn, isPublic, req, res, next))
            .then(() => next())
            .catch(err => {
                if (err.constructor !== Object) {
                    err = {
                        err
                    }
                }
                const httpCode = err.httpCode || 500;
                const message = err.message || defaultMessages[httpCode];
                const code = err.code;
                res.error = err;
                const debugError = config.debug && err.err ? err.err.toString() : undefined;
                res.status(httpCode).send({message, code, debugError});
                next()
            })
    };

async function auth(fn, isPublic, req, res, next) {
    if (!isPublic) {
        let tokenRead;
        try {
            tokenRead = await tokenHelper.read(req.headers.authorization);
        } catch (e) {
            throw {httpCode: 403, code: 1, message: 'Token inválido'}
        }
        req.user = tokenRead;
    }

    await fn(req, res, next)
}
