const
    request = require('request-promise'),
    config = require('../../config');

require('chai').should();

let scope = {};

describe('Order', () => {
    describe('GET - Find all', () => {
        it('should return a list of products', async () => {
            const res = await request({
                method: 'get',
                uri: `${config.url}/products`,
                qs: {
                    pageNumber: 0,
                    pageSize: 10
                },
                json: true
            });
            res.should.be.an('array');
        });
    });
    describe('POST - Find all for autocomplete', () => {
        it('should return a list of products for autocomplete', async () => {
            const res = await request({
                method: 'post',
                uri: `${config.url}/clients/autocomplete`,
                json: true
            });
            res.should.be.an('array');
        });
    });
    describe('POST - Add', () => {
        it('should return an ID from the added product', async () => {
            const res = await request({
                method: 'post',
                uri: `${config.url}/products`,
                body: {
                    name: 'Test',
                    unitWeight: 1,
                    price: 7
                },
                json: true
            });
            res.should.be.an('object');
            res.id.should.be.an('number');
            scope.idToUpdate = res.id;
        });
    });
    describe('GET - Find by ID', () => {
        it('should return a product', async () => {
            const res = await request({
                method: 'get',
                uri: `${config.url}/product/${scope.idToUpdate}`,
                json: true
            });
            res.should.be.an('object');
        });
        it('should return httpCode 404 and error code 1 (Produto não encontrado)', async () => {
            try {
                await request({
                    method: 'get',
                    uri: `${config.url}/product/0`,
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
                uri: `${config.url}/product/${scope.idToUpdate}`,
                body: {
                    name: 'Test updated',
                    unitWeight: 1,
                    price: 7
                },
                json: true
            });
        });
    });
    describe('DELETE - Remove', () => {
        it('should not return error', async () => {
            await request({
                method: 'delete',
                uri: `${config.url}/product/${scope.idToUpdate}`,
                json: true
            });
        });
        it('should return httpCode 404 and error code 1 (Produto não encontrado)', async () => {
            try {
                await request({
                    method: 'delete',
                    uri: `${config.url}/product/${scope.idToUpdate}`,
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