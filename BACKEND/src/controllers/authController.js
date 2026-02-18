const authService = require('../services/authService');

async function login(req, res, next) {
  try {
    const result = await authService.login(req.body.email, req.body.password);
    return res.status(200).json(result);
  } catch (error) {
    return next(error);
  }
}

function refresh(req, res, next) {
  try {
    const accessToken = authService.refresh(req.body.refreshToken);
    return res.json({ accessToken });
  } catch (error) {
    return next(error);
  }
}

function logout(req, res) {
  return res.status(200).json({ message: 'Logout exitoso' });
}

module.exports = { login, refresh, logout };
