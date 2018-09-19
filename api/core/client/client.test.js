const
    request = require('request-promise'),
    config = require('../../config');

require('chai').should();

let scope = {};

describe('Client', () => {
    describe('GET - Find all', () => {
        it('should return a list of clients', async () => {
            const res = await request({
                method: 'get',
                uri: `${config.url}/clients`,
                qs: {
                    pageNumber: 0,
                    pageSize: 10
                },
                json: true
            });
            res.should.be.an('array');
            scope.idToFind = res[0].id;
        });
    });
    describe('GET - Find by ID', () => {
        it('should return a client', async () => {
            const res = await request({
                method: 'get',
                uri: `${config.url}/client/${scope.idToFind}`,
                json: true
            });
            res.should.be.an('object');
        });
        it('should return httpCode 404 and error code 1 (Cliente não encontrado)', async () => {
            try {
                await request({
                    method: 'get',
                    uri: `${config.url}/client/0`,
                    json: true
                });
            } catch (res) {
                res.statusCode.should.be.equal(404);
                res.error.code.should.be.equal(1);
            }
        });
    });
    describe('POST - Add', () => {
        it('should return an ID from the added client', async () => {
            const res = await request({
                method: 'post',
                uri: `${config.url}/clients`,
                body: {
                    name: 'Test'
                },
                json: true
            });
            res.should.be.an('object');
            res.id.should.be.an('number');
            scope.idToUpdate = res.id;
        });
    });
    describe('PUT - Update', () => {
        it('should not return error', async () => {
            await request({
                method: 'put',
                uri: `${config.url}/client/${scope.idToUpdate}`,
                body: {
                    name: 'Test updated'
                },
                json: true
            });
        });
    });
    describe('DELETE - Remove', () => {
        it('should not return error', async () => {
            await request({
                method: 'delete',
                uri: `${config.url}/client/${scope.idToUpdate}`,
                json: true
            });
        });
    })
});