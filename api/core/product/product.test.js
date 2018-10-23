const
    request = require('request-promise'),
    config = require('../../config');

require('chai').should();

let scope = {
    token: global.scope && global.scope.token || "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNTQwMjM5Mjg0fQ.Bwa2P7EovI2zGsq8-ftftLo0QD_9_xhZN3N85DZSnsQ"
};

describe('Product', () => {
    describe('GET - Find all', () => {
        it('should return a list of products', async () => {
            const res = await request({
                method: 'get',
                uri: `${config.url}/products`,
                qs: {
                    pageNumber: 0,
                    pageSize: 10
                },
                headers: {
                    'Authorization': scope.token
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
                headers: {
                    'Authorization': scope.token
                },
                json: true
            });
            res.should.be.an('array');
        });
    });
    describe('POST - Add', () => {
        it('should return an ID from the added product', async () => {
            const res = await request({
                method: 'post',
                uri: `${config.url}/product`,
                body: {
                    name: 'Test',
                    weight: 1,
                    price: 7
                },
                headers: {
                    'Authorization': scope.token
                },
                json: true
            });
            res.should.be.an('object');
            res.should.have.property('return');
            res.return.should.be.an('object');
            res.return.should.have.property('id').which.is.an('number');
            scope.idToUpdate = res.return.id;
        });
    });
    describe('GET - Find by ID', () => {
        it('should return a product', async () => {
            const res = await request({
                method: 'get',
                uri: `${config.url}/product/${scope.idToUpdate}`,
                headers: {
                    'Authorization': scope.token
                },
                json: true
            });
            res.should.be.an('object');
        });
        it('should return httpCode 404 and error code 1 (Produto não encontrado)', async () => {
            try {
                await request({
                    method: 'get',
                    uri: `${config.url}/product/0`,
                    headers: {
                        'Authorization': scope.token
                    },
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
                    weight: 1,
                    price: 7
                },
                headers: {
                    'Authorization': scope.token
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
                headers: {
                    'Authorization': scope.token
                },
                json: true
            });
        });
        it('should return httpCode 404 and error code 1 (Produto não encontrado)', async () => {
            try {
                await request({
                    method: 'delete',
                    uri: `${config.url}/product/${scope.idToUpdate}`,
                    headers: {
                        'Authorization': scope.token
                    },
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