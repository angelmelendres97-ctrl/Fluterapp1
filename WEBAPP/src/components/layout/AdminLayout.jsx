import { ROUTES } from '../../utils/constants';
import { MaterialButton } from '../common/MaterialButton';

const menuItems = [
  { path: ROUTES.adminDashboard, label: 'Dashboard', icon: 'dashboard' },
  { path: ROUTES.adminUsers, label: 'Usuarios', icon: 'group' },
  { path: ROUTES.adminRoles, label: 'Roles', icon: 'admin_panel_settings' },
];

export function AdminLayout({ path, navigate, onLogout, children, user }) {
  return (
    <div className="min-h-screen bg-slate-100">
      <div className="flex flex-col md:flex-row">
        <aside className="w-full bg-amed-900 p-4 text-white md:min-h-screen md:w-64">
          <h1 className="text-lg font-bold">AMED EC Admin</h1>
          <p className="mt-1 text-xs text-slate-200">{user?.name}</p>
          <nav className="mt-6 flex gap-2 md:flex-col">
            {menuItems.map((item) => (
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
