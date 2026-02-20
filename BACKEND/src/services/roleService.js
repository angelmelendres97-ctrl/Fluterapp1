const prisma = require('../config/prisma');

async function listRoles() {
  const roles = await prisma.role.findMany({
    where: { deletedAt: null },
    include: { permission: { include: { permission: true } } },
    orderBy: { name: 'asc' },
  });

  return roles.map((role) => ({
    id: role.id,
    name: role.name,
    permissions: role.permission.map((link) => link.permission.code),
  }));
}

async function createRole({ name, permissions }) {
  const created = await prisma.role.create({
    data: {
      name,
      permission: {
        create: permissions.map((code) => ({ permission: { connect: { code } } })),
      },
    },
    include: { permission: { include: { permission: true } } },
  });

  return {
    id: created.id,
    name: created.name,
    permissions: created.permission.map((link) => link.permission.code),
  };
}

async function updateRole(id, { name, permissions }) {
  await prisma.$transaction(async (tx) => {
    await tx.role.update({ where: { id }, data: { name } });
    await tx.rolePermission.deleteMany({ where: { roleId: id } });

    for (const code of permissions) {
      const permission = await tx.permission.findUnique({ where: { code } });
      if (permission) {
        await tx.rolePermission.create({ data: { roleId: id, permissionId: permission.id } });
      }
    }
  });

  return { id, name, permissions };
}

module.exports = { listRoles, createRole, updateRole };
