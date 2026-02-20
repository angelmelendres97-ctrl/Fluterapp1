import { useEffect, useMemo, useState } from 'react';
import { authService } from '../services/authService';
import { AuthContext } from './authContextObject';

const STORAGE_KEY = 'amedec_auth';

export function AuthProvider({ children }) {
  const [session, setSession] = useState(() => {
    const raw = localStorage.getItem(STORAGE_KEY);
    return raw ? JSON.parse(raw) : { user: null, accessToken: '', refreshToken: '' };
  });

  useEffect(() => {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(session));
  }, [session]);

  const login = async (email, password) => {
    const data = await authService.login({ email, password });
    setSession({
      user: data.user,
      accessToken: data.accessToken,
      refreshToken: data.refreshToken,
    });
    return data.user;
  };

  const logout = () => {
    setSession({ user: null, accessToken: '', refreshToken: '' });
  };

  const value = useMemo(
    () => ({
      ...session,
      isAuthenticated: Boolean(session.accessToken),
      login,
      logout,
    }),
    [session],
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}
