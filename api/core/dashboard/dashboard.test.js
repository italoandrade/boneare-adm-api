const
    request = require('request-promise'),
    config = require('../../config');

require('chai').should();

describe('Dashboard', () => {
    describe('GET - Get info', () => {
        it('should return the dashboard info', async () => {
            const res = await request({
                method: 'get',
                uri: `${config.url}/dashboard`,
                json: true
            });
            res.should.not.be.null;
        })
    })
});