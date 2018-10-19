const
    service = require('./dashboard.service');

module.exports = {
    getInfo
};

async function getInfo(req, res) {
    const data = await service.getInfo();

    res.finish(data)
}
