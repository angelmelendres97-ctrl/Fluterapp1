const patientService = require('../services/patientService');

async function listPatients(req, res, next) {
  try {
    const data = await patientService.listPatients(req.query.q || '');
    return res.json(data);
  } catch (error) {
    return next(error);
  }
}

async function getPatientById(req, res, next) {
  try {
    const patient = await patientService.detailPatient(Number(req.params.id));
    return res.json(patient);
  } catch (error) {
    return next(error);
  }
}

async function createPatient(req, res, next) {
  try {
    const patient = await patientService.createPatient(req.body);
    return res.status(201).json(patient);
  } catch (error) {
    return next(error);
  }
}

async function updatePatient(req, res, next) {
  try {
    const patient = await patientService.updatePatient(Number(req.params.id), req.body);
    return res.status(200).json(patient);
  } catch (error) {
    return next(error);
  }
}

module.exports = { listPatients, getPatientById, createPatient, updatePatient };
