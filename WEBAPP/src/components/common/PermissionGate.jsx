import { usePermission } from '../../hooks/usePermission';

export function PermissionGate({ permission, fallback = null, children }) {
  const canAccess = usePermission(permission);
  return canAccess ? children : fallback;
}
