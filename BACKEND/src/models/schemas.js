const Joi = require('joi');

const loginSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().min(6).required(),
});

const userSchema = Joi.object({
  name: Joi.string().min(2).max(120).required(),
  email: Joi.string().email().required(),
  role: Joi.string().valid('admin', 'medico', 'asistente').required(),
  active: Joi.boolean().optional(),
});

const patientSchema = Joi.object({
  firstName: Joi.string().min(2).required(),
  lastName: Joi.string().min(2).required(),
  document: Joi.string().min(4).max(40).required(),
  phone: Joi.string().allow('').default(''),
  email: Joi.string().email().required(),
});

module.exports = { loginSchema, userSchema, patientSchema };
