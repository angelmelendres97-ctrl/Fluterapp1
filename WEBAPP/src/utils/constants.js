export const ROUTES = {
  landing: '/',
  login: '/login',
  adminDashboard: '/admin',
  adminUsers: '/admin/users',
  adminRoles: '/admin/roles',
  adminPatients: '/admin/patients',
  adminAppointments: '/admin/appointments',
  adminCatalogProfileTypes: '/admin/catalogs/profile-types',
  adminCatalogCompanyTypes: '/admin/catalogs/company-types',
  adminCatalogAppointmentTypes: '/admin/catalogs/appointment-types',
};

export const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000/api';

export const PERMISSIONS = {
  usersRead: 'users.read',
  usersWrite: 'users.write',
  rolesRead: 'roles.read',
  rolesWrite: 'roles.write',
  patientsRead: 'patients.read',
  patientsWrite: 'patients.write',
  appointmentsRead: 'appointments.read',
  appointmentsWrite: 'appointments.write',
  catalogsRead: 'catalogs.read',
  catalogsWrite: 'catalogs.write',
};
