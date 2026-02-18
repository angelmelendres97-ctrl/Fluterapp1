const usersService = require('../services/users.service');

const listUsers = async (req, res, next) => {
  try {
    res.json(await usersService.listUsers());
  } catch (error) {
    next(error);
  }
};

const saveUser = async (req, res, next) => {
  try {
    await usersService.saveUser(req.body);
    res.status(201).json({ message: 'Usuario guardado' });
  } catch (error) {
    next(error);
  }
};

const deactivateUser = async (req, res, next) => {
  try {
    await usersService.deactivateUser(Number(req.params.id));
    res.status(204).send();
  } catch (error) {
    next(error);
  }
};

module.exports = { listUsers, saveUser, deactivateUser };
