import { ROUTES } from '../../utils/constants';
import { MaterialButton } from '../common/MaterialButton';

const menuGroups = [
  {
    title: 'General',
    items: [{ path: ROUTES.adminDashboard, label: 'Dashboard', icon: 'dashboard' }],
  },
  {
    title: 'Seguridad',
    items: [
      { path: ROUTES.adminUsers, label: 'Usuarios', icon: 'group' },
      { path: ROUTES.adminRoles, label: 'Roles', icon: 'admin_panel_settings' },
    ],
  },
  {
    title: 'Gestión Médica',
    items: [
      { path: ROUTES.adminPatients, label: 'Pacientes', icon: 'personal_injury' },
      { path: ROUTES.adminAppointments, label: 'Citas', icon: 'event' },
    ],
  },
  {
    title: 'Operaciones / Configuración',
    items: [
      { path: ROUTES.adminCatalogProfileTypes, label: 'Tipos de Perfil', icon: 'badge' },
      { path: ROUTES.adminCatalogCompanyTypes, label: 'Tipos de Empresa', icon: 'business' },
      { path: ROUTES.adminCatalogAppointmentTypes, label: 'Tipos de Cita', icon: 'category' },
    ],
  },
];

export function AdminLayout({ path, navigate, onLogout, children, user }) {
  return (
    <div className="min-h-screen bg-slate-100">
      <div className="flex flex-col md:flex-row">
        <aside className="w-full bg-amed-900 p-4 text-white md:min-h-screen md:w-72">
          <h1 className="text-lg font-bold">AMED EC Admin</h1>
          <p className="mt-1 text-xs text-slate-200">{user?.name}</p>
          <nav className="mt-6 space-y-4">
            {menuGroups.map((group) => (
              <div key={group.title}>
                <p className="mb-2 text-xs uppercase tracking-wide text-slate-300">{group.title}</p>
                <div className="flex gap-2 md:flex-col">
                  {group.items.map((item) => (
                    <button
                      key={item.path}
                      onClick={() => navigate(item.path)}
                      className={`flex items-center gap-2 rounded-xl px-3 py-2 text-left text-sm ${
                        path === item.path ? 'bg-white/20 font-semibold' : 'hover:bg-white/10'
                      }`}
                    >
                      <span className="material-icons text-base">{item.icon}</span>
                      {item.label}
                    </button>
                  ))}
                </div>
              </div>
            ))}
          </nav>
          <MaterialButton variant="secondary" className="mt-6 w-full" onClick={onLogout}>
            Cerrar sesión
          </MaterialButton>
        </aside>
        <main className="w-full p-4 md:p-8">{children}</main>
      </div>
    </div>
  );
}
