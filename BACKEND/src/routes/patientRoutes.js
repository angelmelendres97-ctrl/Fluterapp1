const express = require('express');

const patientController = require('../controllers/patientController');
const { patientSchema } = require('../models/schemas');
const { authenticate, authorize } = require('../middleware/authMiddleware');
const { validateRequest } = require('../middleware/validateRequest');

const router = express.Router();

router.use(authenticate);
router.get('/', authorize('admin', 'medico', 'asistente'), patientController.listPatients);
router.get('/:id', authorize('admin', 'medico', 'asistente'), patientController.getPatientById);
router.post('/', authorize('admin', 'medico'), validateRequest(patientSchema), patientController.createPatient);
router.put('/:id', authorize('admin', 'medico'), validateRequest(patientSchema), patientController.updatePatient);

module.exports = router;
