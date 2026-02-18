const bcrypt = require('bcryptjs');
const prisma = require('../config/prisma');

const listUsers = async () => {
  const users = await prisma.user.findMany({
    where: { deletedAt: null },
    include: { userRoles: { include: { role: true } } },
  });

  return users.map((user) => ({
    id: user.id,
    name: user.name,
    email: user.email,
    active: user.active,
    role: user.userRoles[0]?.role?.name || 'ASSISTANT',
  }));
};

const saveUser = async ({ id, name, email, role }) => {
  const roleEntity = await prisma.role.findUnique({ where: { name: role } });
  if (!roleEntity) throw new Error('Rol no existe');

  if (id) {
    await prisma.user.update({ where: { id }, data: { name, email } });
    await prisma.userRole.deleteMany({ where: { userId: id } });
    await prisma.userRole.create({ data: { userId: id, roleId: roleEntity.id } });
    return;
  }

  const passwordHash = await bcrypt.hash('ChangeMe123!', 10);
  const user = await prisma.user.create({ data: { name, email, passwordHash, active: true } });
  await prisma.userRole.create({ data: { userId: user.id, roleId: roleEntity.id } });
};

const deactivateUser = async (id) => {
  await prisma.user.update({ where: { id }, data: { active: false, deletedAt: new Date() } });
};

module.exports = { listUsers, saveUser, deactivateUser };
