import { useEffect, useState } from 'react';
import { AdminLayout } from '../../components/layout/AdminLayout';
import { DashboardPage } from './DashboardPage';
import { UsersModule } from '../../components/admin/UsersModule';
import { RolesModule } from '../../components/admin/RolesModule';
import { ROUTES, PERMISSIONS } from '../../utils/constants';
import { userService } from '../../services/userService';
import { roleService } from '../../services/roleService';
import { usePermission } from '../../hooks/usePermission';

export function AdminShell({ path, navigate, auth }) {
  const [users, setUsers] = useState([]);
  const [roles, setRoles] = useState([]);
  const canReadUsers = usePermission(PERMISSIONS.usersRead);
  const canWriteUsers = usePermission(PERMISSIONS.usersWrite);
  const canReadRoles = usePermission(PERMISSIONS.rolesRead);
  const canWriteRoles = usePermission(PERMISSIONS.rolesWrite);

  useEffect(() => {
    if (canReadUsers) {
      userService.list(auth.accessToken).then(setUsers).catch(console.error);
    }
    if (canReadRoles) {
      roleService.list(auth.accessToken).then(setRoles).catch(console.error);
    }
  }, [auth.accessToken, canReadRoles, canReadUsers]);

  const contentByPath = {
    [ROUTES.adminDashboard]: <DashboardPage user={auth.user} />,
    [ROUTES.adminUsers]: canReadUsers ? (
      <UsersModule
        users={users}
        canWrite={canWriteUsers}
        onCreate={async (payload) => {
          await userService.create(auth.accessToken, payload);
          setUsers(await userService.list(auth.accessToken));
        }}
        onUpdate={async (id, payload) => {
          await userService.update(auth.accessToken, id, payload);
          setUsers(await userService.list(auth.accessToken));
        }}
      />
    ) : (
      <p>Sin permisos para módulo de usuarios.</p>
    ),
    [ROUTES.adminRoles]: canReadRoles ? (
      <RolesModule
        roles={roles}
        canWrite={canWriteRoles}
        onCreate={async (payload) => {
          await roleService.create(auth.accessToken, payload);
          setRoles(await roleService.list(auth.accessToken));
        }}
        onUpdate={async (id, payload) => {
          await roleService.update(auth.accessToken, id, payload);
          setRoles(await roleService.list(auth.accessToken));
        }}
      />
    ) : (
      <p>Sin permisos para módulo de roles.</p>
    ),
  };

  return (
    <AdminLayout
      path={path}
      navigate={navigate}
      user={auth.user}
      onLogout={() => {
        auth.logout();
        navigate(ROUTES.login);
      }}
    >
      {contentByPath[path] || <DashboardPage user={auth.user} />}
    </AdminLayout>
  );
}
