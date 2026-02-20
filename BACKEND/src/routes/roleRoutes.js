const express = require('express');

const roleController = require('../controllers/roleController');
const { roleSchema } = require('../models/schemas');
const { authenticate, authorizePermission } = require('../middleware/authMiddleware');
const { validateRequest } = require('../middleware/validateRequest');

const router = express.Router();

router.use(authenticate);
router.get('/', authorizePermission('roles.read'), roleController.listRoles);
router.post('/', authorizePermission('roles.write'), validateRequest(roleSchema), roleController.createRole);
router.put('/:id', authorizePermission('roles.write'), validateRequest(roleSchema), roleController.updateRole);

module.exports = router;
