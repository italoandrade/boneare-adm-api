const
    controller = require('./client.controller');

module.exports = {
    findAll: {
        type: 'get',
        path: '/clients',
        method: controller.findAll,
        public: false
    },
    findById: {
        type: 'get',
        path: '/client/:id',
        method: controller.findById,
        public: false
    },
    add: {
        type: 'post',
        path: '/clients',
        method: controller.add,
        public: false
    },
    update: {
        type: 'put',
        path: '/client/:id',
        method: controller.update,
        public: false
    },
    remove: {
        type: 'delete',
        path: '/client/:id',
        method: controller.remove,
        public: false
    }
};