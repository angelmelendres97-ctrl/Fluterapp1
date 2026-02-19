export const ROUTES = {
  landing: '/',
  login: '/login',
  adminDashboard: '/admin',
  adminUsers: '/admin/users',
  adminRoles: '/admin/roles',
};

export const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000/api';

export const PERMISSIONS = {
  usersRead: 'users.read',
  usersWrite: 'users.write',
  rolesRead: 'roles.read',
  rolesWrite: 'roles.write',
};
