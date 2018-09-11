module.exports = {
    ping
};

async function ping(req, res) {
    res.finish({date: new Date()})
}