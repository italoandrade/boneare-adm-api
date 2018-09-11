module.exports = {
    init,
    save
};

async function init(req, res, next) {
    req.log = {
        url: req.url,
        method: req.method,
        startTime: new Date(),
        body: req.body,
        params: req.params,
        query: req.query
    };

    res.finish = (data) => {
        res.response = data;
        res.send(data)
    };

    next()
}

async function save(req, res, next) {
    req.log = {
        ...req.log,
        endTime: new Date(),
        httpCode: res.statusCode,
        response: res.response,
        error: res.error
    };
    req.log.time = (req.log.endTime.getTime() - req.log.startTime.getTime()) + 'ms';

    console.info('[Log]:', req.log);

    next()
}