const prisma = require('../config/prisma');

async function listPatients(query = '') {
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
}

async function detailPatient(id) {
  const patient = await prisma.patient.findUnique({ where: { id } });
  if (!patient || patient.deletedAt) {
    const err = new Error('Paciente no encontrado');
    err.status = 404;
    throw err;
  }

  return patient;
}

async function createPatient(data) {
  return prisma.patient.create({ data });
}

async function updatePatient(id, data) {
  return prisma.patient.update({ where: { id }, data });
}

module.exports = { listPatients, detailPatient, createPatient, updatePatient };
