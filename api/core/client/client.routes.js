const
    controller = require('./client.controller');

module.exports = {
    list: {
        type: 'get',
        path: '/clients',
        method: controller.list,
        public: false
    }
};