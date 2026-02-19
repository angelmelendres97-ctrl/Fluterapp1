import { useMemo } from 'react';
import { useAuth } from './useAuth';

export function usePermission(permissionCode) {
  const { user } = useAuth();

  return useMemo(() => {
    if (!user) return false;
    return user.permissions?.includes(permissionCode) || false;
  }, [permissionCode, user]);
}
