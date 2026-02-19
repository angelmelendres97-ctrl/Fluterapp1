const express = require('express');
const Joi = require('joi');

const catalogController = require('../controllers/catalogController');
const { authenticate, authorizePermission } = require('../middleware/authMiddleware');
const { validateRequest } = require('../middleware/validateRequest');

const router = express.Router();

const catalogItemSchema = Joi.object({
  code: Joi.string().max(100).allow(null, ''),
  name: Joi.string().min(2).max(120).required(),
  description: Joi.string().allow('', null),
  active: Joi.boolean().default(true),
  parentId: Joi.number().integer().allow(null),
});

router.use(authenticate);
router.get('/:catalog', authorizePermission('catalogs.read'), catalogController.listCatalog);
router.post('/:catalog', authorizePermission('catalogs.write'), validateRequest(catalogItemSchema), catalogController.createCatalogItem);

module.exports = router;
