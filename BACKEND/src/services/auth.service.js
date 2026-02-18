const bcrypt = require('bcryptjs');
const prisma = require('../config/prisma');
const { signAccessToken, signRefreshToken, verifyRefreshToken } = require('../utils/jwt');

const login = async ({ email, password }) => {
  const user = await prisma.user.findFirst({
    where: { email, active: true, deletedAt: null },
    include: { userRoles: { include: { role: true } } },
  });

  if (!user || !(await bcrypt.compare(password, user.passwordHash))) {
    throw new Error('Credenciales inválidas');
  }

  const role = user.userRoles[0]?.role?.name || 'ASSISTANT';
  const payload = { userId: user.id, email: user.email, role };
  const accessToken = signAccessToken(payload);
  const refreshToken = signRefreshToken(payload);

  await prisma.refreshToken.create({
    data: {
      token: refreshToken,
      userId: user.id,
      expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
    },
  });

  return {
    accessToken,
    refreshToken,
    user: { id: user.id, name: user.name, email: user.email, role },
  };
};

const refresh = async (refreshToken) => {
  const payload = verifyRefreshToken(refreshToken);
  const persisted = await prisma.refreshToken.findUnique({ where: { token: refreshToken } });
  if (!persisted) {
    throw new Error('Refresh token inválido');
  }
  return { accessToken: signAccessToken({ userId: payload.userId, email: payload.email, role: payload.role }) };
};

const logout = async (refreshToken) => {
  await prisma.refreshToken.deleteMany({ where: { token: refreshToken } });
};

module.exports = { login, refresh, logout };
