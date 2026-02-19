import { useState } from 'react';
import { MaterialButton } from '../common/MaterialButton';
import { SectionTitle } from '../common/SectionTitle';

export function CatalogModule({ title, subtitle, items, canWrite, onCreate }) {
  const [form, setForm] = useState({ code: '', name: '', description: '', active: true });

  return (
    <div className="space-y-5">
      <SectionTitle title={title} subtitle={subtitle} />
      <div className="material-card overflow-x-auto p-4">
        <table className="w-full text-left text-sm">
          <thead><tr className="border-b border-slate-200 text-slate-500"><th className="py-2">Código</th><th>Nombre</th><th>Estado</th></tr></thead>
          <tbody>
            {items.map((item) => <tr key={item.id} className="border-b border-slate-100"><td className="py-2">{item.code || '-'}</td><td>{item.name}</td><td>{item.active ? 'Activo' : 'Inactivo'}</td></tr>)}
          </tbody>
        </table>
      </div>
      {canWrite ? (
        <div className="material-card grid gap-3 p-4 md:grid-cols-2">
          <input className="rounded-xl border border-slate-200 px-3 py-2" placeholder="Código" value={form.code} onChange={(e) => setForm({ ...form, code: e.target.value })} />
          <input className="rounded-xl border border-slate-200 px-3 py-2" placeholder="Nombre" value={form.name} onChange={(e) => setForm({ ...form, name: e.target.value })} />
          <textarea className="rounded-xl border border-slate-200 px-3 py-2 md:col-span-2" placeholder="Descripción" value={form.description} onChange={(e) => setForm({ ...form, description: e.target.value })} />
          <div className="md:col-span-2"><MaterialButton onClick={() => onCreate(form)}>Crear registro</MaterialButton></div>
        </div>
      ) : null}
    </div>
  );
}
