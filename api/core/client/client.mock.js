const CLIENTS = [
    {id: 1, name: 'TestTestTestTestTestTestTest1', lineCount: 15},
    {id: 2, name: 'TestTestTestTestTestTestTest2', lineCount: 15},
    {id: 3, name: 'TestTestTestTestTestTestTest3', lineCount: 15},
    {id: 4, name: 'TestTestTestTestTestTestTest4', lineCount: 15},
    {id: 5, name: 'TestTestTestTestTestTestTest5', lineCount: 15},
    {id: 6, name: 'TestTestTestTestTestTestTest6', lineCount: 15},
    {id: 7, name: 'TestTestTestTestTestTestTest7', lineCount: 15},
    {id: 8, name: 'TestTestTestTestTestTestTest8', lineCount: 15},
    {id: 9, name: 'TestTestTestTestTestTestTest9', lineCount: 15},
    {id: 10, name: 'TestTestTestTestTestTestTest10', lineCount: 15},
    {id: 11, name: 'TestTestTestTestTestTestTest11', lineCount: 15},
    {id: 12, name: 'TestTestTestTestTestTestTest12', lineCount: 15},
    {id: 13, name: 'TestTestTestTestTestTestTest13', lineCount: 15},
    {id: 14, name: 'TestTestTestTestTestTestTest14', lineCount: 15},
    {id: 15, name: 'TestTestTestTestTestTestTest15', lineCount: 15}
];

module.exports = {
    findAll,
    findById,
    add,
    update
};

async function findAll(params) {
    return CLIENTS.filter(i => (+params.pageNumber === 0 && i.id <= +params.pageSize) || (+params.pageNumber === 1 && i.id >= +params.pageSize + 1 && i.id <= +params.pageSize * 2) || (+params.pageNumber === 2 && i.id >= +params.pageSize * 3))
}

async function findById(params) {
    const filtered = CLIENTS.filter(i => i.id === +params.id)[0];
    if (filtered) {
        return {
            id: filtered.id,
            name: filtered.name,
            createdBy: 'Ítalo Andrade',
            creationDate: '2018-09-18T20:08:25.490Z',
            updatedBy: 'Suellen Andrade',
            lastUpdateDate: '2018-09-18T20:19:46.490Z'
        }
    } else {
        return null;
    }
}

async function add(params) {
    const newId = CLIENTS[CLIENTS.length - 1].id + 1;

    CLIENTS.push({
        id: newId,
        name: params.name
    });

    CLIENTS.forEach(i => i.lineCount = CLIENTS.length);

    return {
        id: newId
    }
}

async function update(params) {
    const clientToEdit = CLIENTS.filter(i => +i.id === +params.id)[0];
    console.log(CLIENTS);
    console.log(params);
    clientToEdit.name = params.name;
}