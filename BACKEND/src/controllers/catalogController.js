const catalogService = require('../services/catalogService');

async function listCatalog(req, res, next) {
  try {
    const data = await catalogService.listCatalog(req.params.catalog);
    return res.json(data);
  } catch (error) {
    return next(error);
  }
}

async function createCatalogItem(req, res, next) {
  try {
    const data = await catalogService.createCatalogItem(req.params.catalog, req.body);
    return res.status(201).json(data);
  } catch (error) {
    return next(error);
  }
}

module.exports = { listCatalog, createCatalogItem };
