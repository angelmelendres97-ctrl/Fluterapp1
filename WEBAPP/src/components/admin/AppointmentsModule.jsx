import { useState } from 'react';
import { MaterialButton } from '../common/MaterialButton';
import { SectionTitle } from '../common/SectionTitle';

const defaultForm = { patientId: '', companyId: '', appointmentTypeId: '', status: 'PENDING', scheduledAt: '', notes: '', price: 0 };

export function AppointmentsModule({ data, canWrite, onSearch, onCreate }) {
  const [query, setQuery] = useState('');
  const [form, setForm] = useState(defaultForm);

  return (
    <div className="space-y-5">
      <SectionTitle title="Gestión Médica · Citas" subtitle="Agenda clínica y estado operativo" />
      <div className="material-card p-4">
        <div className="flex flex-col gap-2 md:flex-row">
          <input className="rounded-xl border border-slate-200 px-3 py-2" placeholder="Buscar cita, paciente o estado" value={query} onChange={(e) => setQuery(e.target.value)} />
          <MaterialButton onClick={() => onSearch(query)}>Buscar</MaterialButton>
        </div>
      </div>
      <div className="material-card overflow-x-auto p-4">
        <table className="w-full min-w-[760px] text-left text-sm">
          <thead>
            <tr className="border-b border-slate-200 text-slate-500">
              <th className="py-2">Paciente</th>
              <th>Tipo</th>
              <th>Estado</th>
              <th>Fecha</th>
              <th>Empresa</th>
            </tr>
          </thead>
          <tbody>
            {data.items.map((appointment) => (
              <tr key={appointment.id} className="border-b border-slate-100">
                <td className="py-2">{appointment.patient.firstName} {appointment.patient.lastName}</td>
                <td>{appointment.appointmentType.name}</td>
                <td>{appointment.status}</td>
                <td>{appointment.scheduledAt ? new Date(appointment.scheduledAt).toLocaleString() : '-'}</td>
                <td>{appointment.company?.name || '-'}</td>
              </tr>
            ))}
          </tbody>
        </table>
        <p className="mt-3 text-xs text-slate-500">Mostrando página {data.page} · Total registros: {data.total}</p>
      </div>
      {canWrite ? (
        <div className="material-card grid gap-3 p-4 md:grid-cols-2">
          <input className="rounded-xl border border-slate-200 px-3 py-2" placeholder="ID Paciente" value={form.patientId} onChange={(e) => setForm({ ...form, patientId: Number(e.target.value) })} />
          <input className="rounded-xl border border-slate-200 px-3 py-2" placeholder="ID Tipo Cita" value={form.appointmentTypeId} onChange={(e) => setForm({ ...form, appointmentTypeId: Number(e.target.value) })} />
          <input className="rounded-xl border border-slate-200 px-3 py-2" placeholder="ID Empresa (opcional)" value={form.companyId} onChange={(e) => setForm({ ...form, companyId: e.target.value ? Number(e.target.value) : null })} />
          <select className="rounded-xl border border-slate-200 px-3 py-2" value={form.status} onChange={(e) => setForm({ ...form, status: e.target.value })}>
            <option value="PENDING">PENDING</option><option value="SCHEDULED">SCHEDULED</option><option value="CANCELLED">CANCELLED</option><option value="COMPLETED">COMPLETED</option>
          </select>
          <input type="datetime-local" className="rounded-xl border border-slate-200 px-3 py-2" value={form.scheduledAt} onChange={(e) => setForm({ ...form, scheduledAt: e.target.value })} />
          <input className="rounded-xl border border-slate-200 px-3 py-2" placeholder="Precio" type="number" value={form.price} onChange={(e) => setForm({ ...form, price: Number(e.target.value) })} />
          <textarea className="rounded-xl border border-slate-200 px-3 py-2 md:col-span-2" placeholder="Notas" value={form.notes} onChange={(e) => setForm({ ...form, notes: e.target.value })} />
          <div className="md:col-span-2"><MaterialButton onClick={() => onCreate(form)}>Crear cita</MaterialButton></div>
        </div>
      ) : null}
    </div>
  );
}
