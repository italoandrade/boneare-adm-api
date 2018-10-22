const
    request = require('request-promise'),
    config = require('../../config');

require('chai').should();

let scope = {};

describe('User', () => {
    describe('POST - Sign in', () => {
        it('should return user\'s info and token when using credentials', async () => {
            const res = await request({
                method: 'post',
                uri: `${config.url}/user/sign-in`,
                body: {
                    email: 'test@test.com',
                    password: 'test'
                },
                json: true
            });
            res.user.should.be.not.null;
            res.token.should.be.not.null;
            scope.token = res.token;
            global.scope.token = res.token;
        });

        it('should return user\'s info and token when using token', async () => {
            const res = await request({
                method: 'post',
                uri: `${config.url}/user/sign-in`,
                headers: {
                    'Authentication': scope.token
                },
                json: true
            });
            res.user.should.be.not.null;
            res.token.should.be.not.null;
        });

        it('should return httpCode 403 and error code 1 (Usuário não encontrado)', async () => {
            try {
                await request({
                    method: 'post',
                    uri: `${config.url}/user/sign-in`,
                    body: {
                        email: 'test2@test.com',
                        password: 'test'
                    },
                    json: true
                });
            } catch (res) {
                res.statusCode.should.be.equal(403);
                res.error.code.should.be.equal(1);
            }
        });

        it('should return httpCode 403 and error code 2 (Senha incorreta)', async () => {
            try {
                await request({
                    method: 'post',
                    uri: `${config.url}/user/sign-in`,
                    body: {
                        email: 'test@test.com',
                        password: 'test2'
                    },
                    json: true
                });
            } catch (res) {
                res.statusCode.should.be.equal(403);
                res.error.code.should.be.equal(2);
            }
        });

        it('should return httpCode 403 and error code 3 (Token inválido)', async () => {
            try {
                await request({
                    method: 'post',
                    uri: `${config.url}/user/sign-in`,
                    headers: {
                        'Authentication': 'INVALIDTOKEN'
                    },
                    json: true
                });
            } catch (res) {
                res.statusCode.should.be.equal(403);
                res.error.code.should.be.equal(3);
            }
        });
    })
});