const express = require('express');

const patientController = require('../controllers/patientController');
const { patientSchema } = require('../models/schemas');
const { authenticate, authorizePermission } = require('../middleware/authMiddleware');
const { validateRequest } = require('../middleware/validateRequest');

const router = express.Router();

router.use(authenticate);
router.get('/', authorizePermission('patients.read'), patientController.listPatients);
router.get('/:id', authorizePermission('patients.read'), patientController.getPatientById);
router.post('/', authorizePermission('patients.write'), validateRequest(patientSchema), patientController.createPatient);
router.put('/:id', authorizePermission('patients.write'), validateRequest(patientSchema), patientController.updatePatient);

module.exports = router;
