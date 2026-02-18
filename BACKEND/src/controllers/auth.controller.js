const authService = require('../services/auth.service');

const login = async (req, res, next) => {
  try {
    const result = await authService.login(req.body);
    res.json(result);
  } catch (error) {
    next(error);
  }
};

const refresh = async (req, res, next) => {
  try {
    const result = await authService.refresh(req.body.refreshToken);
    res.json(result);
  } catch (error) {
    next(error);
  }
};

const logout = async (req, res, next) => {
  try {
    await authService.logout(req.body.refreshToken);
    res.status(204).send();
  } catch (error) {
    next(error);
  }
};

module.exports = { login, refresh, logout };
