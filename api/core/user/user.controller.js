const service = require('./user.service');

module.exports = {
    signIn
};

async function signIn(req, res) {
    const params = {
        email: req.body.email,
        password: req.body.password,
        token: req.headers.authentication
    };

    const data = await service.signIn(params);

    res.finish(data)
}