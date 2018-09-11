const
    mock = require('./user.mock');

module.exports = {
    signIn
};

async function signIn(req, res) {
    const user = {
        email: req.body.email,
        password: req.body.password
    };

    const userInfo = await mock.signIn(user);

    res.finish(userInfo)
}