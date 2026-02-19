const express = require('express');
const authRoutes = require('./authRoutes');
const userRoutes = require('./userRoutes');
const patientRoutes = require('./patientRoutes');
const roleRoutes = require('./roleRoutes');
const appointmentRoutes = require('./appointmentRoutes');
const catalogRoutes = require('./catalogRoutes');

const router = express.Router();

router.use('/auth', authRoutes);
router.use('/users', userRoutes);
router.use('/roles', roleRoutes);
router.use('/patients', patientRoutes);
router.use('/appointments', appointmentRoutes);
router.use('/catalogs', catalogRoutes);

module.exports = router;
