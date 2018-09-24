const
    controller = require('./product.controller');

module.exports = {
    findAll: {
        type: 'get',
        path: '/products',
        method: controller.findAll,
        public: false
    },
    findById: {
        type: 'get',
        path: '/product/:id',
        method: controller.findById,
        public: false
    },
    add: {
        type: 'post',
        path: '/products',
        method: controller.add,
        public: false
    },
    update: {
        type: 'put',
        path: '/product/:id',
        method: controller.update,
        public: false
    },
    remove: {
        type: 'delete',
        path: '/product/:id',
        method: controller.remove,
        public: false
    }
};