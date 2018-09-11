const
    controller = require('./ping.controller');

module.exports = {
    ping: {
        type: 'get',
        path: '/ping',
        method: controller.ping
    }
};