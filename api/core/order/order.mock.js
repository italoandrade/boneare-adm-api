let DATA = [
    {id: 1, description: 'Pedido teste', client: 'Cliente teste', totalCost: 7, totalCostAll: 7, lineCount: 1}
];

module.exports = {
    findAll,
    findById,
    add,
    update,
    remove
};

async function findAll(params) {
    return DATA.filter(i => (+params.pageNumber === 0 && i.id <= +params.pageSize) || (+params.pageNumber === 1 && i.id >= +params.pageSize + 1 && i.id <= +params.pageSize * 2) || (+params.pageNumber === 2 && i.id > +params.pageSize * 2))
}

async function findById(params) {
    const filtered = DATA.filter(i => i.id === +params.id)[0];
    if (filtered) {
        return filtered
    }

    return null;
}

async function add(params) {
    const newId = (DATA[DATA.length - 1] ? DATA[DATA.length - 1].id : 0) + 1;

    DATA.push({
        id: newId,
        description: params.description,
        unitWeight: params.unitWeight,
        price: params.price,
        createdBy: 'Teste',
        creationDate: new Date().toISOString(),
        updatedBy: null,
        lastUpdateDate: null
    });

    DATA.forEach(i => i.lineCount = DATA.length);

    return {
        id: newId
    }
}

async function update(params) {
    let toEdit = DATA.filter(i => +i.id === +params.id);
    if (!toEdit.length) {
        throw {httpCode: 404, code: 1, message: 'Pedido não encontrado'}
    }

    toEdit = toEdit[0];

    toEdit.description = params.description;
    toEdit.unitWeight = params.unitWeight;
    toEdit.price = params.price;
    toEdit.updatedBy = 'Teste';
    toEdit.lastUpdateDate = new Date().toISOString();
}

async function remove(params) {
    const existing = DATA.filter(i => +i.id === +params.id);
    if (!existing.length) {
        throw {httpCode: 404, code: 1, message: 'Pedido não encontrado'}
    }

    DATA = DATA.filter(i => +i.id !== +params.id);
}