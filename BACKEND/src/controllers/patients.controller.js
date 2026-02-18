const patientsService = require('../services/patients.service');

const listPatients = async (req, res, next) => {
  try {
    const query = req.query.query || '';
    res.json(await patientsService.listPatients(query));
  } catch (error) {
    next(error);
  }
};

const savePatient = async (req, res, next) => {
  try {
    await patientsService.savePatient({ ...req.body, createdBy: req.user?.userId });
    res.status(201).json({ message: 'Paciente guardado' });
  } catch (error) {
    next(error);
  }
};

module.exports = { listPatients, savePatient };
