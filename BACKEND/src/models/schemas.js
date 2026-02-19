const Joi = require('joi');

const paginationSchema = Joi.object({
  page: Joi.number().integer().min(1).default(1),
  pageSize: Joi.number().integer().min(1).max(100).default(10),
  q: Joi.string().allow('').default(''),
});

const loginSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().min(6).required(),
});

const userSchema = Joi.object({
  name: Joi.string().min(2).max(120).required(),
  email: Joi.string().email().required(),
  role: Joi.string().required(),
  active: Joi.boolean().optional(),
});

const roleSchema = Joi.object({
  name: Joi.string().min(3).max(50).required(),
  permissions: Joi.array().items(Joi.string()).min(1).required(),
});

const patientSchema = Joi.object({
  firstName: Joi.string().min(2).required(),
  lastName: Joi.string().min(2).required(),
  document: Joi.string().min(4).max(40).required(),
  phone: Joi.string().allow('').default(''),
  email: Joi.string().email().required(),
});

const appointmentSchema = Joi.object({
  patientId: Joi.number().integer().required(),
  companyId: Joi.number().integer().allow(null),
  appointmentTypeId: Joi.number().integer().required(),
  status: Joi.string().valid('PENDING', 'SCHEDULED', 'CANCELLED', 'COMPLETED').default('PENDING'),
  scheduledAt: Joi.date().iso().allow(null),
  notes: Joi.string().allow('', null),
  price: Joi.number().min(0).default(0),
});

module.exports = { loginSchema, userSchema, roleSchema, patientSchema, appointmentSchema, paginationSchema };
