import { useState } from 'react';
import { SectionTitle } from '../../components/common/SectionTitle';
import { MaterialButton } from '../../components/common/MaterialButton';

export function LoginPage({ onSubmit, error, loading, onBack }) {
  const [form, setForm] = useState({ email: 'admin@amedec.com', password: 'Admin123*' });

  return (
    <div className="flex min-h-screen items-center justify-center bg-slate-100 p-4">
      <div className="material-card w-full max-w-md p-6">
        <SectionTitle
          title="Ingreso Administrativo"
          subtitle="Autenticación JWT para módulos internos de AMED EC"
        />
        <form
          className="space-y-4"
          onSubmit={(event) => {
            event.preventDefault();
            onSubmit(form);
          }}
        >
          <label className="block text-sm">
            Email
            <input
              className="mt-1 w-full rounded-xl border border-slate-200 px-3 py-2"
              type="email"
              value={form.email}
              onChange={(event) => setForm({ ...form, email: event.target.value })}
              required
            />
          </label>
          <label className="block text-sm">
            Contraseña
            <input
              className="mt-1 w-full rounded-xl border border-slate-200 px-3 py-2"
              type="password"
              value={form.password}
              onChange={(event) => setForm({ ...form, password: event.target.value })}
              required
            />
          </label>
          {error ? <p className="text-sm text-red-600">{error}</p> : null}
          <div className="flex gap-2">
            <MaterialButton className="w-full" disabled={loading}>
              {loading ? 'Validando...' : 'Ingresar'}
            </MaterialButton>
            <MaterialButton type="button" variant="secondary" onClick={onBack}>
              Volver
            </MaterialButton>
          </div>
        </form>
      </div>
    </div>
  );
}
