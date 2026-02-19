const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const prisma = require('../config/prisma');
const env = require('../config/env');

async function login(email, password) {
  const user = await prisma.user.findFirst({
    where: { email, deletedAt: null },
    include: {
      userRoles: {
        include: {
          role: {
            include: {
              permission: { include: { permission: true } },
            },
          },
        },
      },
    },
  });

  if (!user || !(await bcrypt.compare(password, user.passwordHash))) {
    const err = new Error('Credenciales inválidas');
    err.status = 401;
    throw err;
  }

  const roles = user.userRoles.map((userRole) => userRole.role.name);
  const permissions = [...new Set(user.userRoles.flatMap((userRole) => userRole.role.permission.map((link) => link.permission.code)))];

  const payload = { userId: user.id, roles, permissions };

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
      roles,
      permissions,
    },
  };
}

function refresh(refreshToken) {
  try {
    const decoded = jwt.verify(refreshToken, env.jwtRefreshSecret);
    return jwt.sign(
      { userId: decoded.userId, roles: decoded.roles, permissions: decoded.permissions },
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
