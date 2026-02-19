import { useEffect, useState } from 'react';
import { AdminLayout } from '../../components/layout/AdminLayout';
import { DashboardPage } from './DashboardPage';
import { UsersModule } from '../../components/admin/UsersModule';
import { RolesModule } from '../../components/admin/RolesModule';
import { PatientsModule } from '../../components/admin/PatientsModule';
import { AppointmentsModule } from '../../components/admin/AppointmentsModule';
import { CatalogModule } from '../../components/admin/CatalogModule';
import { ROUTES, PERMISSIONS } from '../../utils/constants';
import { userService } from '../../services/userService';
import { roleService } from '../../services/roleService';
import { patientService } from '../../services/patientService';
import { appointmentService } from '../../services/appointmentService';
import { catalogService } from '../../services/catalogService';
import { usePermission } from '../../hooks/usePermission';

export function AdminShell({ path, navigate, auth }) {
  const [users, setUsers] = useState([]);
  const [roles, setRoles] = useState([]);
  const [patients, setPatients] = useState([]);
  const [appointments, setAppointments] = useState({ items: [], total: 0, page: 1, pageSize: 10 });
  const [profileTypes, setProfileTypes] = useState([]);
  const [companyTypes, setCompanyTypes] = useState([]);
  const [appointmentTypes, setAppointmentTypes] = useState([]);

  const canReadUsers = usePermission(PERMISSIONS.usersRead);
  const canWriteUsers = usePermission(PERMISSIONS.usersWrite);
  const canReadRoles = usePermission(PERMISSIONS.rolesRead);
  const canWriteRoles = usePermission(PERMISSIONS.rolesWrite);
  const canReadPatients = usePermission(PERMISSIONS.patientsRead);
  const canWritePatients = usePermission(PERMISSIONS.patientsWrite);
  const canReadAppointments = usePermission(PERMISSIONS.appointmentsRead);
  const canWriteAppointments = usePermission(PERMISSIONS.appointmentsWrite);
  const canReadCatalogs = usePermission(PERMISSIONS.catalogsRead);
  const canWriteCatalogs = usePermission(PERMISSIONS.catalogsWrite);

  useEffect(() => {
    if (canReadUsers) userService.list(auth.accessToken).then(setUsers).catch(console.error);
    if (canReadRoles) roleService.list(auth.accessToken).then(setRoles).catch(console.error);
    if (canReadPatients) patientService.list(auth.accessToken).then(setPatients).catch(console.error);
    if (canReadAppointments) appointmentService.list(auth.accessToken).then(setAppointments).catch(console.error);
    if (canReadCatalogs) {
      catalogService.list(auth.accessToken, 'profileTypes').then(setProfileTypes).catch(console.error);
      catalogService.list(auth.accessToken, 'companyTypes').then(setCompanyTypes).catch(console.error);
      catalogService.list(auth.accessToken, 'appointmentTypes').then(setAppointmentTypes).catch(console.error);
    }
  }, [auth.accessToken, canReadAppointments, canReadCatalogs, canReadPatients, canReadRoles, canReadUsers]);

  const contentByPath = {
    [ROUTES.adminDashboard]: <DashboardPage user={auth.user} />,
    [ROUTES.adminUsers]: canReadUsers ? (
      <UsersModule users={users} canWrite={canWriteUsers} onCreate={async (payload) => { await userService.create(auth.accessToken, payload); setUsers(await userService.list(auth.accessToken)); }} onUpdate={async (id, payload) => { await userService.update(auth.accessToken, id, payload); setUsers(await userService.list(auth.accessToken)); }} />
    ) : <p>Sin permisos para módulo de usuarios.</p>,
    [ROUTES.adminRoles]: canReadRoles ? (
      <RolesModule roles={roles} canWrite={canWriteRoles} onCreate={async (payload) => { await roleService.create(auth.accessToken, payload); setRoles(await roleService.list(auth.accessToken)); }} onUpdate={async (id, payload) => { await roleService.update(auth.accessToken, id, payload); setRoles(await roleService.list(auth.accessToken)); }} />
    ) : <p>Sin permisos para módulo de roles.</p>,
    [ROUTES.adminPatients]: canReadPatients ? (
      <PatientsModule
        patients={patients}
        canWrite={canWritePatients}
        onSearch={async (q) => setPatients(await patientService.list(auth.accessToken, q))}
        onCreate={async (payload) => { await patientService.create(auth.accessToken, payload); setPatients(await patientService.list(auth.accessToken)); }}
        onUpdate={async (id, payload) => { await patientService.update(auth.accessToken, id, payload); setPatients(await patientService.list(auth.accessToken)); }}
      />
    ) : <p>Sin permisos para módulo de pacientes.</p>,
    [ROUTES.adminAppointments]: canReadAppointments ? (
      <AppointmentsModule
        data={appointments}
        canWrite={canWriteAppointments}
        onSearch={async (q) => setAppointments(await appointmentService.list(auth.accessToken, { q }))}
        onCreate={async (payload) => { await appointmentService.create(auth.accessToken, payload); setAppointments(await appointmentService.list(auth.accessToken)); }}
      />
    ) : <p>Sin permisos para módulo de citas.</p>,
    [ROUTES.adminCatalogProfileTypes]: canReadCatalogs ? (
      <CatalogModule title="Configuración · Tipos de perfil" subtitle="Catálogo de perfiles del sistema" items={profileTypes} canWrite={canWriteCatalogs} onCreate={async (payload) => { await catalogService.create(auth.accessToken, 'profileTypes', payload); setProfileTypes(await catalogService.list(auth.accessToken, 'profileTypes')); }} />
    ) : <p>Sin permisos para catálogos.</p>,
    [ROUTES.adminCatalogCompanyTypes]: canReadCatalogs ? (
      <CatalogModule title="Operaciones · Tipos de empresa" subtitle="Clasificación institucional" items={companyTypes} canWrite={canWriteCatalogs} onCreate={async (payload) => { await catalogService.create(auth.accessToken, 'companyTypes', payload); setCompanyTypes(await catalogService.list(auth.accessToken, 'companyTypes')); }} />
    ) : <p>Sin permisos para catálogos.</p>,
    [ROUTES.adminCatalogAppointmentTypes]: canReadCatalogs ? (
      <CatalogModule title="Operaciones · Tipos de cita" subtitle="Canales de atención médica" items={appointmentTypes} canWrite={canWriteCatalogs} onCreate={async (payload) => { await catalogService.create(auth.accessToken, 'appointmentTypes', payload); setAppointmentTypes(await catalogService.list(auth.accessToken, 'appointmentTypes')); }} />
    ) : <p>Sin permisos para catálogos.</p>,
  };

  return (
    <AdminLayout path={path} navigate={navigate} user={auth.user} onLogout={() => { auth.logout(); navigate(ROUTES.login); }}>
      {contentByPath[path] || <DashboardPage user={auth.user} />}
    </AdminLayout>
  );
}
