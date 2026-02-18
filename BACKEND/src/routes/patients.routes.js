const express = require('express');
const { listPatients, savePatient } = require('../controllers/patients.controller');
const authMiddleware = require('../middlewares/auth.middleware');
const roleMiddleware = require('../middlewares/role.middleware');

const router = express.Router();

router.use(authMiddleware);
router.get('/', roleMiddleware('ADMIN', 'DOCTOR', 'ASSISTANT'), listPatients);
router.post('/', roleMiddleware('ADMIN', 'DOCTOR', 'ASSISTANT'), savePatient);

module.exports = router;
