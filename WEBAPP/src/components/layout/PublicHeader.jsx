import { MaterialButton } from '../common/MaterialButton';

export function PublicHeader({ onLoginClick }) {
  return (
    <header className="mx-auto flex w-full max-w-6xl items-center justify-between px-6 py-5">
      <div>
        <p className="text-xl font-extrabold text-amed-700">AMED EC</p>
        <p className="text-xs text-slate-500">Asistencia Médica Ecuador</p>
      </div>
      <MaterialButton onClick={onLoginClick}>Ingresar al Sistema</MaterialButton>
    </header>
  );
}
