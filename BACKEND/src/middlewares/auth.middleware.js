const { verifyAccessToken } = require('../utils/jwt');

const authMiddleware = (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (!authHeader?.startsWith('Bearer ')) {
    return res.status(401).json({ message: 'Token requerido' });
  }

  try {
    const token = authHeader.split(' ')[1];
    req.user = verifyAccessToken(token);
    return next();
  } catch (_) {
    return res.status(401).json({ message: 'Token inválido o expirado' });
  }
};

module.exports = authMiddleware;
