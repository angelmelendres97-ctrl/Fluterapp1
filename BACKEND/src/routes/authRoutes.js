const express = require('express');

const authController = require('../controllers/authController');
const { loginSchema } = require('../models/schemas');
const { validateRequest } = require('../middleware/validateRequest');

const router = express.Router();

router.post('/login', validateRequest(loginSchema), authController.login);
router.post('/refresh', authController.refresh);
router.post('/logout', authController.logout);

module.exports = router;
