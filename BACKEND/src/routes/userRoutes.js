const express = require('express');

const userController = require('../controllers/userController');
const { userSchema } = require('../models/schemas');
const { authenticate, authorize } = require('../middleware/authMiddleware');
const { validateRequest } = require('../middleware/validateRequest');

const router = express.Router();

router.use(authenticate);
router.get('/', authorize('admin'), userController.listUsers);
router.post('/', authorize('admin'), validateRequest(userSchema), userController.createUser);
router.put('/:id', authorize('admin'), validateRequest(userSchema), userController.updateUser);

module.exports = router;
