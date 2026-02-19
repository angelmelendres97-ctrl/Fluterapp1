import { useMemo, useState } from 'react';
import { MaterialButton } from '../common/MaterialButton';
import { SectionTitle } from '../common/SectionTitle';

const defaultForm = { firstName: '', lastName: '', document: '', phone: '', email: '' };

export function PatientsModule({ patients, canWrite, onCreate, onUpdate, onSearch }) {
  const [form, setForm] = useState(defaultForm);
  const [editingId, setEditingId] = useState(null);
  const [query, setQuery] = useState('');

  const sortedPatients = useMemo(
    () => [...patients].sort((a, b) => a.lastName.localeCompare(b.lastName)),
    [patients],
  );

  const submit = () => {
    if (editingId) {
      onUpdate(editingId, form);
    } else {
      onCreate(form);
    }
    setEditingId(null);
    setForm(defaultForm);
  };

  return (
    <div className="space-y-5">
      <SectionTitle title="Gestión Médica · Pacientes" subtitle="Historia base de pacientes y contacto" />
      <div className="material-card p-4">
        <div className="flex flex-col gap-2 md:flex-row">
          <input
            className="rounded-xl border border-slate-200 px-3 py-2"
            placeholder="Buscar por nombre o documento"
            value={query}
            onChange={(event) => setQuery(event.target.value)}
          />
          <MaterialButton onClick={() => onSearch(query)}>Buscar</MaterialButton>
        </div>
      </div>

      <div className="material-card overflow-x-auto p-4">
        <table className="w-full min-w-[640px] text-left text-sm">
          <thead>
            <tr className="border-b border-slate-200 text-slate-500">
              <th className="py-2">Nombres</th>
              <th>Documento</th>
              <th>Teléfono</th>
              <th>Email</th>
              {canWrite ? <th>Acciones</th> : null}
            </tr>
          </thead>
          <tbody>
            {sortedPatients.map((patient) => (
              <tr className="border-b border-slate-100" key={patient.id}>
                <td className="py-2">{patient.firstName} {patient.lastName}</td>
                <td>{patient.document}</td>
                <td>{patient.phone || '-'}</td>
                <td>{patient.email}</td>
                {canWrite ? (
                  <td>
                    <button
                      className="text-amed-700"
                      onClick={() => {
                        setEditingId(patient.id);
                        setForm(patient);
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
          <input className="rounded-xl border border-slate-200 px-3 py-2" placeholder="Nombres" value={form.firstName} onChange={(e) => setForm({ ...form, firstName: e.target.value })} />
          <input className="rounded-xl border border-slate-200 px-3 py-2" placeholder="Apellidos" value={form.lastName} onChange={(e) => setForm({ ...form, lastName: e.target.value })} />
          <input className="rounded-xl border border-slate-200 px-3 py-2" placeholder="Documento" value={form.document} onChange={(e) => setForm({ ...form, document: e.target.value })} />
          <input className="rounded-xl border border-slate-200 px-3 py-2" placeholder="Teléfono" value={form.phone} onChange={(e) => setForm({ ...form, phone: e.target.value })} />
          <input className="rounded-xl border border-slate-200 px-3 py-2 md:col-span-2" placeholder="Email" value={form.email} onChange={(e) => setForm({ ...form, email: e.target.value })} />
          <div className="md:col-span-2">
            <MaterialButton onClick={submit}>{editingId ? 'Actualizar' : 'Crear'} paciente</MaterialButton>
          </div>
        </div>
      ) : null}
    </div>
  );
}
