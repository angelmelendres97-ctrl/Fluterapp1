const bcrypt = require('bcryptjs');
const prisma = require('../config/prisma');

async function listUsers() {
  const rows = await prisma.user.findMany({
    where: { deletedAt: null },
    include: { userRoles: { include: { role: true } } },
    orderBy: { createdAt: 'desc' },
  });

  return rows.map((u) => ({
    id: u.id,
    name: u.name,
    email: u.email,
    active: u.active,
    role: u.userRoles[0]?.role?.name || 'asistente',
  }));
}

async function createUser({ name, email, role }) {
  const passwordHash = await bcrypt.hash('ChangeMe123', 10);

  const created = await prisma.user.create({
    data: {
      name,
      email,
      passwordHash,
      userRoles: {
        create: {
          role: {
            connect: { name: role },
          },
        },
      },
    },
  });

  return created;
}

async function updateUser(id, { name, email, role, active }) {
  await prisma.$transaction(async (tx) => {
    await tx.user.update({ where: { id }, data: { name, email, active } });
    await tx.userRole.deleteMany({ where: { userId: id } });
    await tx.userRole.create({
      data: {
        userId: id,
        role: { connect: { name: role } },
      },
    });
  });
}

module.exports = { listUsers, createUser, updateUser };
