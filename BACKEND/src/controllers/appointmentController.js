const appointmentService = require('../services/appointmentService');

async function listAppointments(req, res, next) {
  try {
    const data = await appointmentService.listAppointments(req.query);
    return res.json(data);
  } catch (error) {
    return next(error);
  }
}

async function createAppointment(req, res, next) {
  try {
    const created = await appointmentService.createAppointment(req.body);
    return res.status(201).json(created);
  } catch (error) {
    return next(error);
  }
}

async function updateAppointment(req, res, next) {
  try {
    const updated = await appointmentService.updateAppointment(Number(req.params.id), req.body);
    return res.json(updated);
  } catch (error) {
    return next(error);
  }
}

module.exports = { listAppointments, createAppointment, updateAppointment };
