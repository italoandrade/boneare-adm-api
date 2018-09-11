const
    request = require('request-promise'),
    config = require('../../config');

require('chai').should();

describe('Ping', () => {
    describe('GET - Ping', () => {
        it('should be success and return today\'s date', async () => {
            const res = await request({
                uri: `${config.url}/ping`,
                json: true
            });
            res.date.should.be.a('string');
        })
    })
});