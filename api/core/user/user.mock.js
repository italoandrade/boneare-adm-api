module.exports = {
    signIn
};

async function signIn(user) {
    const userInfo = {
        id: 1,
        name: 'Test',
        email: 'test@test.com',
        color: 1,
        picture: null,
        correctPassword: user.password === 'test'
    };

    if (user.id) {
        return userInfo;
    } else {
        if (user.email !== 'test@test.com') {
            return null;
        }

        return userInfo;
    }
}