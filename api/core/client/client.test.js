const
    request = require('request-promise'),
    config = require('../../config');

require('chai').should();

let scope = {
    document: Math.floor(Math.random() * 255).toString(),
    token: global.scope && global.scope.token || "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNTQwMjM5Mjg0fQ.Bwa2P7EovI2zGsq8-ftftLo0QD_9_xhZN3N85DZSnsQ"
};

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
                headers: {
                    'Authorization': scope.token
                },
                json: true
            });
            res.should.be.an('array');
        });
    });
    describe('POST - Find all for autocomplete', () => {
        it('should return a list of clients for autocomplete', async () => {
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
        it('should return an ID from the added client', async () => {
            try {
                const res = await request({
                    method: 'post',
                    uri: `${config.url}/clients`,
                    body: {
                        name: 'Test',
                        document: scope.document
                    },
                    headers: {
                        'Authorization': scope.token
                    },
                    json: true
                });
                console.log(res);
                res.should.be.an('object');
                res.should.have.property('return');
                res.return.should.be.an('object');
                res.return.should.have.property('id').which.is.an('number');
                scope.idToUpdate = res.return.id;
            } catch (err) {
                throw err;
            }
        });
        it('should return httpCode 409 and error code 2 (Documento existente)', async () => {
            try {
                await request({
                    method: 'post',
                    uri: `${config.url}/clients`,
                    body: {
                        name: 'Test',
                        document: scope.document
                    },
                    headers: {
                        'Authorization': scope.token
                    },
                    json: true
                });
                throw 'should not succeed';
            } catch (res) {
                res.should.not.be.equal('should not succeed');
                res.statusCode.should.be.equal(409);
                res.error.code.should.be.equal(1);
            }
        });
    });
    describe('GET - Find by ID', () => {
        it('should return a client', async () => {
            const res = await request({
                method: 'get',
                uri: `${config.url}/client/${scope.idToUpdate}`,
                headers: {
                    'Authorization': scope.token
                },
                json: true
            });
            res.should.be.an('object');
        });
        it('should return httpCode 404 and error code 1 (Cliente não encontrado)', async () => {
            try {
                await request({
                    method: 'get',
                    uri: `${config.url}/client/0`,
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
                uri: `${config.url}/client/${scope.idToUpdate}`,
                body: {
                    name: 'Test updated'
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
                uri: `${config.url}/client/${scope.idToUpdate}`,
                headers: {
                    'Authorization': scope.token
                },
                json: true
            });
        });
        it('should return httpCode 404 and error code 1 (Cliente não encontrado)', async () => {
            try {
                await request({
                    method: 'delete',
                    uri: `${config.url}/client/${scope.idToUpdate}`,
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