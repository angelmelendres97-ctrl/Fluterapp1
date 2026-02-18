const prisma = require('../config/prisma');

const listPatients = async (query = '') => {
  return prisma.patient.findMany({
    where: {
      deletedAt: null,
      OR: [
        { firstName: { contains: query, mode: 'insensitive' } },
        { lastName: { contains: query, mode: 'insensitive' } },
        { document: { contains: query, mode: 'insensitive' } },
      ],
    },
    orderBy: { createdAt: 'desc' },
  });
};

const savePatient = async ({ id, firstName, lastName, document, phone, createdBy }) => {
  if (id) {
    return prisma.patient.update({ where: { id }, data: { firstName, lastName, document, phone } });
  }

  return prisma.patient.create({ data: { firstName, lastName, document, phone, createdBy } });
};

module.exports = { listPatients, savePatient };
