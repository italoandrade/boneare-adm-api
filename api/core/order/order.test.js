const
    request = require('request-promise'),
    config = require('../../config');

require('chai').should();

let scope = {};

describe('Order', () => {
    describe('GET - Find all', () => {
        it('should return a list of orders', async () => {
            const res = await request({
                method: 'get',
                uri: `${config.url}/orders`,
                qs: {
                    pageNumber: 0,
                    pageSize: 10
                },
                json: true
            });
            res.should.be.an('array');
        });
    });
    describe('POST - Add', () => {
        it('should return an ID from the added order', async () => {
            const res = await request({
                method: 'post',
                uri: `${config.url}/orders`,
                body: {
                    name: 'Test',
                    document: '1'
                },
                json: true
            });
            res.should.be.an('object');
            res.id.should.be.an('number');
            scope.idToUpdate = res.id;
        });
    });
    describe('GET - Find by ID', () => {
        it('should return a order', async () => {
            const res = await request({
                method: 'get',
                uri: `${config.url}/order/${scope.idToUpdate}`,
                json: true
            });
            res.should.be.an('object');
        });
        it('should return httpCode 404 and error code 1 (Pedido não encontrado)', async () => {
            try {
                await request({
                    method: 'get',
                    uri: `${config.url}/order/0`,
                    json: true
                });
                throw 'should not succeed';
            } catch (res) {
                res.should.not.be.equal('should not succeed');
                res.statusCode.should.be.equal(404);
                res.error.code.should.be.equal(1);
            }
        });
    });
    describe('PUT - Update', () => {
        it('should not return error', async () => {
            await request({
                method: 'put',
                uri: `${config.url}/order/${scope.idToUpdate}`,
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
                uri: `${config.url}/order/${scope.idToUpdate}`,
                json: true
            });
        });
        it('should return httpCode 404 and error code 1 (Pedido não encontrado)', async () => {
            try {
                await request({
                    method: 'delete',
                    uri: `${config.url}/order/${scope.idToUpdate}`,
                    json: true
                });
                throw 'should not succeed';
            } catch (res) {
                res.should.not.be.equal('should not succeed');
                res.statusCode.should.be.equal(404);
                res.error.code.should.be.equal(1);
            }
        });
    })
});