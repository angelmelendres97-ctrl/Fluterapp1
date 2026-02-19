const prisma = require('../config/prisma');

function toPagination(page = 1, pageSize = 10) {
  const take = Math.max(Number(pageSize) || 10, 1);
  const skip = (Math.max(Number(page) || 1, 1) - 1) * take;
  return { take, skip };
}

async function listAppointments({ q = '', page = 1, pageSize = 10 }) {
  const filters = q
    ? {
        OR: [
          { status: { contains: q, mode: 'insensitive' } },
          { patient: { firstName: { contains: q, mode: 'insensitive' } } },
          { patient: { lastName: { contains: q, mode: 'insensitive' } } },
          { patient: { document: { contains: q, mode: 'insensitive' } } },
        ],
      }
    : {};

  const { take, skip } = toPagination(page, pageSize);
  const [items, total] = await prisma.$transaction([
    prisma.appointment.findMany({
      where: filters,
      include: {
        patient: true,
        company: true,
        appointmentType: true,
      },
      orderBy: { createdAt: 'desc' },
      take,
      skip,
    }),
    prisma.appointment.count({ where: filters }),
  ]);

  return { items, total, page: Number(page), pageSize: take };
}

async function createAppointment(data) {
  return prisma.appointment.create({ data });
}

async function updateAppointment(id, data) {
  return prisma.appointment.update({ where: { id }, data });
}

module.exports = { listAppointments, createAppointment, updateAppointment };
