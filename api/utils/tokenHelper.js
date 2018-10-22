const
    jwt = require('jsonwebtoken'),
    config = require('../config');

module.exports = {
    create,
    read
};

async function create(data) {
    return jwt.sign(data, config.hash);
}

async function read(token) {
    return jwt.verify(token.replace('Bearer ', ''), config.hash);
}