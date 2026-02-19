const express = require('express');

const userController = require('../controllers/userController');
const { userSchema } = require('../models/schemas');
const { authenticate, authorizePermission } = require('../middleware/authMiddleware');
const { validateRequest } = require('../middleware/validateRequest');

const router = express.Router();

router.use(authenticate);
router.get('/', authorizePermission('users.read'), userController.listUsers);
router.post('/', authorizePermission('users.write'), validateRequest(userSchema), userController.createUser);
router.put('/:id', authorizePermission('users.write'), validateRequest(userSchema), userController.updateUser);

module.exports = router;
