const defaultMessages = {
    404: 'Recurso não foi encontrado',
    500: 'Ocorreu um erro interno'
};

module.exports = fn =>
    (req, res, next) => {
        Promise.resolve(fn(req, res, next))
            .then(() => next())
            .catch(err => {
                const httpCode = err.httpCode || 500;
                const message = err.message || defaultMessages[httpCode];
                res.error = err;
                res.status(httpCode).send({message});
                next()
            })
    };