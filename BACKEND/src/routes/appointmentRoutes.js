const express = require('express');

const appointmentController = require('../controllers/appointmentController');
const { appointmentSchema } = require('../models/schemas');
const { authenticate, authorizePermission } = require('../middleware/authMiddleware');
const { validateRequest } = require('../middleware/validateRequest');

const router = express.Router();

router.use(authenticate);
router.get('/', authorizePermission('appointments.read'), appointmentController.listAppointments);
router.post('/', authorizePermission('appointments.write'), validateRequest(appointmentSchema), appointmentController.createAppointment);
router.put('/:id', authorizePermission('appointments.write'), validateRequest(appointmentSchema), appointmentController.updateAppointment);

module.exports = router;
