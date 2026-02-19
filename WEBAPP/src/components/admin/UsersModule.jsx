import { useState } from 'react';
import { MaterialButton } from '../common/MaterialButton';
import { SectionTitle } from '../common/SectionTitle';

const defaultForm = { name: '', email: '', role: 'asistente', active: true };

export function UsersModule({ users, onCreate, onUpdate, canWrite }) {
  const [form, setForm] = useState(defaultForm);
  const [editingId, setEditingId] = useState(null);

  const submit = () => {
    if (editingId) {
      onUpdate(editingId, form);
    } else {
      onCreate(form);
    }
    setForm(defaultForm);
    setEditingId(null);
  };

  return (
    <div className="space-y-5">
      <SectionTitle title="Gestión de Usuarios" subtitle="Administración de accesos de personal" />
      <div className="material-card overflow-x-auto p-4">
        <table className="w-full min-w-[640px] text-left text-sm">
          <thead>
            <tr className="border-b border-slate-200 text-slate-500">
              <th className="py-2">Nombre</th>
              <th>Email</th>
              <th>Rol</th>
              <th>Estado</th>
              {canWrite ? <th>Acciones</th> : null}
            </tr>
          </thead>
          <tbody>
            {users.map((user) => (
              <tr key={user.id} className="border-b border-slate-100">
                <td className="py-2">{user.name}</td>
                <td>{user.email}</td>
                <td>{user.role}</td>
                <td>{user.active ? 'Activo' : 'Inactivo'}</td>
                {canWrite ? (
                  <td>
                    <button
                      className="text-amed-700"
                      onClick={() => {
                        setEditingId(user.id);
                        setForm({
                          name: user.name,
                          email: user.email,
                          role: user.role,
                          active: user.active,
                        });
                      }}
                    >
                      Editar
                    </button>
                  </td>
                ) : null}
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {canWrite ? (
        <div className="material-card grid gap-3 p-4 md:grid-cols-2">
          <input
            className="rounded-xl border border-slate-200 px-3 py-2"
            placeholder="Nombre"
            value={form.name}
            onChange={(event) => setForm({ ...form, name: event.target.value })}
          />
          <input
            className="rounded-xl border border-slate-200 px-3 py-2"
            placeholder="Email"
            value={form.email}
            onChange={(event) => setForm({ ...form, email: event.target.value })}
          />
          <select
            className="rounded-xl border border-slate-200 px-3 py-2"
            value={form.role}
            onChange={(event) => setForm({ ...form, role: event.target.value })}
          >
            <option value="admin">admin</option>
            <option value="medico">medico</option>
            <option value="asistente">asistente</option>
          </select>
          <label className="flex items-center gap-2 text-sm">
            <input
              type="checkbox"
              checked={form.active}
              onChange={(event) => setForm({ ...form, active: event.target.checked })}
            />
            Usuario activo
          </label>
          <div className="md:col-span-2">
            <MaterialButton onClick={submit}>{editingId ? 'Actualizar' : 'Crear'} usuario</MaterialButton>
          </div>
        </div>
      ) : null}
    </div>
  );
}
