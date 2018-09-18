const
    controller = require('./client.controller');

module.exports = {
    listAll: {
        type: 'get',
        path: '/clients',
        method: controller.listAll,
        public: false
    }
};