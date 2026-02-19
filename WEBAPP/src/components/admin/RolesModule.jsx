import { useState } from 'react';
import { SectionTitle } from '../common/SectionTitle';
import { MaterialButton } from '../common/MaterialButton';

const permissionCatalog = ['users.read', 'users.write', 'roles.read', 'roles.write', 'patients.read', 'patients.write'];

export function RolesModule({ roles, canWrite, onCreate, onUpdate }) {
  const [name, setName] = useState('');
  const [permissions, setPermissions] = useState(['roles.read']);

  const togglePermission = (permission) => {
    setPermissions((previous) =>
      previous.includes(permission)
        ? previous.filter((item) => item !== permission)
        : [...previous, permission],
    );
  };

  return (
    <div className="space-y-5">
      <SectionTitle title="Gestión de Roles" subtitle="Definición de perfiles y permisos" />
      <div className="grid gap-4 md:grid-cols-2">
        {roles.map((role) => (
          <div className="material-card p-4" key={role.id}>
            <h3 className="text-lg font-semibold text-amed-900">{role.name}</h3>
            <p className="mt-2 text-xs uppercase text-slate-500">Permisos asignados</p>
            <div className="mt-2 flex flex-wrap gap-2">
              {role.permissions.map((permission) => (
                <span key={permission} className="rounded-full bg-amed-50 px-2 py-1 text-xs text-amed-700">
                  {permission}
                </span>
              ))}
            </div>
            {canWrite ? (
              <button
                className="mt-3 text-sm text-amed-700"
                onClick={() => onUpdate(role.id, { name: role.name, permissions: role.permissions })}
              >
                Guardar configuración actual
              </button>
            ) : null}
          </div>
        ))}
      </div>

      {canWrite ? (
        <div className="material-card p-4">
          <h4 className="font-semibold">Crear rol</h4>
          <input
            className="mt-3 w-full rounded-xl border border-slate-200 px-3 py-2"
            placeholder="Nombre del rol"
            value={name}
            onChange={(event) => setName(event.target.value)}
          />
          <div className="mt-4 grid gap-2 md:grid-cols-3">
            {permissionCatalog.map((permission) => (
              <label key={permission} className="flex items-center gap-2 text-sm">
                <input
                  type="checkbox"
                  checked={permissions.includes(permission)}
                  onChange={() => togglePermission(permission)}
                />
                {permission}
              </label>
            ))}
          </div>
          <MaterialButton
            className="mt-4"
            onClick={() => {
              onCreate({ name, permissions });
              setName('');
            }}
          >
            Crear rol
          </MaterialButton>
        </div>
      ) : null}
    </div>
  );
}
