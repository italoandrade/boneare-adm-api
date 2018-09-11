const
    request = require('request-promise'),
    config = require('../../config');

require('chai').should();

describe('User', () => {
    describe('POST - Sign in', () => {
        it('should return user\'s info and token', async () => {
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
        })
    })
});