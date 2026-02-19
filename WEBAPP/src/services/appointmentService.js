import { httpClient } from './httpClient';

export const appointmentService = {
  list: (token, { q = '', page = 1, pageSize = 10 } = {}) =>
    httpClient.request(`/appointments?q=${encodeURIComponent(q)}&page=${page}&pageSize=${pageSize}`, { token }),
  create: (token, payload) => httpClient.request('/appointments', { method: 'POST', token, body: payload }),
  update: (token, id, payload) => httpClient.request(`/appointments/${id}`, { method: 'PUT', token, body: payload }),
};
