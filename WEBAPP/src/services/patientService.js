import { httpClient } from './httpClient';

export const patientService = {
  list: (token, q = '') => httpClient.request(`/patients?q=${encodeURIComponent(q)}`, { token }),
  create: (token, payload) => httpClient.request('/patients', { method: 'POST', token, body: payload }),
  update: (token, id, payload) => httpClient.request(`/patients/${id}`, { method: 'PUT', token, body: payload }),
};
