const userService = require('../services/userService');

async function listUsers(req, res, next) {
  try {
    const users = await userService.listUsers();
    return res.json(users);
  } catch (error) {
    return next(error);
  }
}

async function createUser(req, res, next) {
  try {
    const user = await userService.createUser(req.body);
    return res.status(201).json(user);
  } catch (error) {
    return next(error);
  }
}

async function updateUser(req, res, next) {
  try {
    await userService.updateUser(Number(req.params.id), req.body);
    return res.status(204).send();
  } catch (error) {
    return next(error);
  }
}

module.exports = { listUsers, createUser, updateUser };
