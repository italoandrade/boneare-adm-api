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
    findAutocomplete: {
        type: 'post',
        path: '/clients/autocomplete',
        method: controller.findAutocomplete,
        public: false
    },
    add: {
        type: 'post',
        path: '/client',
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