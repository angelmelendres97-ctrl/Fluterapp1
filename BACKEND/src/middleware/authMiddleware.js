const jwt = require('jsonwebtoken');
const env = require('../config/env');

function authenticate(req, res, next) {
  const authHeader = req.headers.authorization;
  if (!authHeader?.startsWith('Bearer ')) {
    return res.status(401).json({ message: 'Token no proporcionado' });
  }

  const token = authHeader.split(' ')[1];

  try {
    const payload = jwt.verify(token, env.jwtAccessSecret);
    req.user = payload;
    return next();
  } catch {
    return res.status(401).json({ message: 'Token inválido' });
  }
}

function authorize(...roles) {
  return (req, res, next) => {
    const userRoles = req.user?.roles || [];
    if (!req.user || !roles.some((role) => userRoles.includes(role))) {
      return res.status(403).json({ message: 'Sin permisos para este recurso' });
    }
    return next();
  };
}

function authorizePermission(...permissions) {
  return (req, res, next) => {
    const currentPermissions = req.user?.permissions || [];
    if (!permissions.some((permission) => currentPermissions.includes(permission))) {
      return res.status(403).json({ message: 'Permiso insuficiente para este recurso' });
    }
    return next();
  };
}

module.exports = { authenticate, authorize, authorizePermission };
