import { API_BASE_URL } from '../utils/constants';

async function request(path, { method = 'GET', body, token } = {}) {
  const response = await fetch(`${API_BASE_URL}${path}`, {
    method,
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
    },
    body: body ? JSON.stringify(body) : undefined,
  });

  if (!response.ok) {
    const errorPayload = await response.json().catch(() => ({}));
    throw new Error(errorPayload.message || 'Error de comunicación con el servidor');
  }

  if (response.status === 204) {
    return null;
  }

  return response.json();
}

export const httpClient = { request };
