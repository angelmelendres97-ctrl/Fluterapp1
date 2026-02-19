import { httpClient } from './httpClient';

export const userService = {
  list: (token) => httpClient.request('/users', { token }),
  create: (token, payload) => httpClient.request('/users', { method: 'POST', token, body: payload }),
  update: (token, id, payload) => httpClient.request(`/users/${id}`, { method: 'PUT', token, body: payload }),
};
