const express = require('express');
const authRoutes = require('./auth.routes');
const usersRoutes = require('./users.routes');
const patientsRoutes = require('./patients.routes');

const router = express.Router();

router.use('/auth', authRoutes);
router.use('/users', usersRoutes);
router.use('/patients', patientsRoutes);

module.exports = router;
