const
    controller = require('./user.controller');

module.exports = {
    signIn: {
        type: 'post',
        path: '/user/sign-in',
        method: controller.signIn,
        public: true
    }
};