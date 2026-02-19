import { httpClient } from './httpClient';

export const catalogService = {
  list: (token, catalog) => httpClient.request(`/catalogs/${catalog}`, { token }),
  create: (token, catalog, payload) => httpClient.request(`/catalogs/${catalog}`, { method: 'POST', token, body: payload }),
};
