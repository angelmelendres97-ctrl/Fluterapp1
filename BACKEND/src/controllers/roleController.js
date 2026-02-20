const roleService = require('../services/roleService');

async function listRoles(req, res, next) {
  try {
    const roles = await roleService.listRoles();
    return res.json(roles);
  } catch (error) {
    return next(error);
  }
}

async function createRole(req, res, next) {
  try {
    const role = await roleService.createRole(req.body);
    return res.status(201).json(role);
  } catch (error) {
    return next(error);
  }
}

async function updateRole(req, res, next) {
  try {
    const role = await roleService.updateRole(Number(req.params.id), req.body);
    return res.json(role);
  } catch (error) {
    return next(error);
  }
}

module.exports = { listRoles, createRole, updateRole };
