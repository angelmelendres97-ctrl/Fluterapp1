import { SectionTitle } from '../../components/common/SectionTitle';

export function DashboardPage({ user }) {
  return (
    <div>
      <SectionTitle
        title="Panel Administrativo AMED EC"
        subtitle="Control centralizado de operación web para Asistencia Médica Ecuador"
      />
      <div className="grid gap-4 md:grid-cols-3">
        <article className="material-card p-4">
          <p className="text-slate-500">Usuario autenticado</p>
          <p className="mt-2 text-lg font-bold">{user?.name}</p>
        </article>
        <article className="material-card p-4">
          <p className="text-slate-500">Rol principal</p>
          <p className="mt-2 text-lg font-bold">{user?.roles?.[0] || '-'}</p>
        </article>
        <article className="material-card p-4">
          <p className="text-slate-500">Permisos cargados</p>
          <p className="mt-2 text-lg font-bold">{user?.permissions?.length || 0}</p>
        </article>
      </div>
    </div>
  );
}
