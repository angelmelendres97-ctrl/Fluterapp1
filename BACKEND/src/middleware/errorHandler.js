const { logError } = require('../utils/logger');

function errorHandler(err, req, res, next) {
  logError(err.message, { stack: err.stack, path: req.path });
  const status = err.status || 500;
  return res.status(status).json({
    message: err.message || 'Error interno del servidor',
  });
}

module.exports = { errorHandler };
