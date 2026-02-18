function validateRequest(schema) {
  return (req, res, next) => {
    const { error } = schema.validate(req.body, { abortEarly: false });
    if (error) {
      return res.status(400).json({
        message: 'Datos inválidos',
        details: error.details.map((d) => d.message),
      });
    }
    return next();
  };
}

module.exports = { validateRequest };
