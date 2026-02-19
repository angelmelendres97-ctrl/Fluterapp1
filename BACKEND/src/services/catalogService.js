const prisma = require('../config/prisma');

const catalogMap = {
  profileTypes: prisma.profileType,
  companyTypes: prisma.companyType,
  appointmentTypes: prisma.appointmentType,
  productCategories: prisma.productCategory,
};

function getModel(catalog) {
  const model = catalogMap[catalog];
  if (!model) {
    const error = new Error('Catálogo no soportado');
    error.status = 400;
    throw error;
  }
  return model;
}

async function listCatalog(catalog) {
  const model = getModel(catalog);
  return model.findMany({ orderBy: { name: 'asc' } });
}

async function createCatalogItem(catalog, payload) {
  const model = getModel(catalog);
  return model.create({ data: payload });
}

module.exports = { listCatalog, createCatalogItem };
