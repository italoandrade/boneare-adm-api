const
    controller = require('./order.controller');

module.exports = {
    findAll: {
        type: 'get',
        path: '/orders',
        method: controller.findAll,
        public: false
    },
    findById: {
        type: 'get',
        path: '/order/:id',
        method: controller.findById,
        public: false
    },
    add: {
        type: 'post',
        path: '/orders',
        method: controller.add,
        public: false
    },
    update: {
        type: 'put',
        path: '/order/:id',
        method: controller.update,
        public: false
    },
    remove: {
        type: 'delete',
        path: '/order/:id',
        method: controller.remove,
        public: false
    }
};