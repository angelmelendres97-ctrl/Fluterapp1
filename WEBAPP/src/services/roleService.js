import { httpClient } from './httpClient';

export const roleService = {
  list: (token) => httpClient.request('/roles', { token }),
  create: (token, payload) => httpClient.request('/roles', { method: 'POST', token, body: payload }),
  update: (token, id, payload) => httpClient.request(`/roles/${id}`, { method: 'PUT', token, body: payload }),
};
