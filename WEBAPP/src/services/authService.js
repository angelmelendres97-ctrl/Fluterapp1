import { httpClient } from './httpClient';

export const authService = {
  login: (payload) => httpClient.request('/auth/login', { method: 'POST', body: payload }),
  refresh: (refreshToken) => httpClient.request('/auth/refresh', { method: 'POST', body: { refreshToken } }),
};
