import { createContext } from 'react';

export const AuthContext = createContext({
  user: null,
  accessToken: '',
  refreshToken: '',
  isAuthenticated: false,
  login: async () => {},
  logout: () => {},
});
