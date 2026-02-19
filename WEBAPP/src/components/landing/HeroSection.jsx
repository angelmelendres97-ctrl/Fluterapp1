import { MaterialButton } from '../common/MaterialButton';

export function HeroSection({ onLoginClick }) {
  return (
    <section className="mx-auto grid w-full max-w-6xl gap-6 px-6 py-10 md:grid-cols-2 md:items-center">
      <div>
        <p className="mb-3 inline-flex rounded-full bg-amed-50 px-3 py-1 text-xs font-semibold text-amed-700">
          Atención 24/7 | Call Center permanente
        </p>
        <h1 className="text-4xl font-extrabold leading-tight text-amed-900 md:text-5xl">
          Asistencia Médica inmediata para Ecuador en un solo clic.
        </h1>
        <p className="mt-4 text-slate-600">
          AMED EC conecta médicos, pacientes y procesos administrativos para servicios online y
          presenciales todos los días de la semana.
        </p>
        <div className="mt-6 flex flex-wrap gap-3">
          <MaterialButton onClick={onLoginClick}>Ingresar al Portal</MaterialButton>
          <MaterialButton variant="secondary">Conocer Planes</MaterialButton>
        </div>
      </div>
      <div className="material-card p-6">
        <h3 className="text-lg font-bold text-amed-900">¿Qué ofrece AMED EC?</h3>
        <ul className="mt-4 space-y-3 text-slate-700">
          <li>• Videoconsulta y derivación presencial.</li>
          <li>• Triaje inicial con respuesta médica inmediata.</li>
          <li>• Gestión centralizada de usuarios, roles y permisos.</li>
          <li>• Monitoreo operativo para equipos administrativos.</li>
        </ul>
      </div>
    </section>
  );
}
