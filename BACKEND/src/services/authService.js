const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const prisma = require('../config/prisma');
const env = require('../config/env');

async function login(email, password) {
  const user = await prisma.user.findFirst({
    where: { email, deletedAt: null },
    include: { userRoles: { include: { role: true } } },
  });

  if (!user || !(await bcrypt.compare(password, user.passwordHash))) {
    const err = new Error('Credenciales inválidas');
    err.status = 401;
    throw err;
  }

  const role = user.userRoles[0]?.role?.name || 'asistente';
  const payload = { userId: user.id, role };

  const accessToken = jwt.sign(payload, env.jwtAccessSecret, {
    expiresIn: env.accessTokenExpiresIn,
  });
  const refreshToken = jwt.sign(payload, env.jwtRefreshSecret, {
    expiresIn: env.refreshTokenExpiresIn,
  });

  return {
    accessToken,
    refreshToken,
    user: {
      id: user.id,
      name: user.name,
      email: user.email,
      role,
    },
  };
}

function refresh(refreshToken) {
  try {
    const decoded = jwt.verify(refreshToken, env.jwtRefreshSecret);
    return jwt.sign(
      { userId: decoded.userId, role: decoded.role },
      env.jwtAccessSecret,
      { expiresIn: env.accessTokenExpiresIn },
    );
  } catch {
    const err = new Error('Refresh token inválido');
    err.status = 401;
    throw err;
  }
}

module.exports = { login, refresh };
