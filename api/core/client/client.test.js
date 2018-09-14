const
    request = require('request-promise'),
    config = require('../../config');

require('chai').should();

describe('Client', () => {
    describe('GET - List', () => {
        it('should return a list of clients', async () => {
            const res = await request({
                method: 'get',
                uri: `${config.url}/clients`,
                json: true
            });
            res.should.be.an('array');
        });
    })
});