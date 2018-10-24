let DATA = {
    clients: 2,
    balance: 50.0,
    stock: 0.5
};

module.exports = {
    getInfo
};

async function getInfo() {
    return DATA;
}
