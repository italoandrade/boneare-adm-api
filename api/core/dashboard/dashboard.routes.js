const
    controller = require('./dashboard.controller');

module.exports = {
    getInfo: {
        type: 'get',
        path: '/dashboard',
        method: controller.getInfo,
        public: false
    }
};