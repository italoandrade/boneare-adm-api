let DATA = [
    {id: 1, name: 'Cliente teste 1', lineCount: 10},
    {id: 2, name: 'Cliente teste 2', lineCount: 10},
    {id: 3, name: 'Cliente teste 3', lineCount: 10},
    {id: 4, name: 'Cliente teste 4', lineCount: 10},
    {id: 5, name: 'Cliente teste 5', lineCount: 10},
    {id: 6, name: 'Cliente teste 6', lineCount: 10},
    {id: 7, name: 'Cliente teste 7', lineCount: 10},
    {id: 8, name: 'Cliente teste 8', lineCount: 10},
    {id: 9, name: 'Cliente teste 9', lineCount: 10},
    {id: 10, name: 'Cliente teste 10', lineCount: 10}
];

module.exports = {
    findAll,
    findById,
    findAutocomplete,
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

async function findAutocomplete(params) {
    return DATA.filter(x => (!params.filter || x.name.indexOf(params.filter) > -1) && !(params.unless || []).includes(x.id)).slice(0, 7);
}

async function add(params) {
    const existingDocument = DATA.filter(i => i.document === params.document);
    if (existingDocument.length) {
        throw {httpCode: 409, code: 1, message: 'Documento existente'}
    }

    const newId = (DATA[DATA.length - 1] ? DATA[DATA.length - 1].id : 0) + 1;

    DATA.push({
        id: newId,
        name: params.name,
        document: params.document,
        description: params.description,
        address: params.address,
        phones: params.phones,
        emails: params.emails,
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
        throw {httpCode: 404, code: 1, message: 'Cliente não encontrado'}
    }

    toEdit = toEdit[0];

    toEdit.name = params.name;
    toEdit.document = params.document;
    toEdit.description = params.description;
    toEdit.address = params.address;
    toEdit.phones = params.phones;
    toEdit.emails = params.emails;
    toEdit.updatedBy = 'Teste';
    toEdit.lastUpdateDate = new Date().toISOString();
}

async function remove(params) {
    const existing = DATA.filter(i => +i.id === +params.id);
    if (!existing.length) {
        throw {httpCode: 404, code: 1, message: 'Cliente não encontrado'}
    }

    DATA = DATA.filter(i => +i.id !== +params.id);
}