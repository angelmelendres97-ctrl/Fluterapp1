# AMED EC WebApp

Frontend Web para **Asistencia Médica Ecuador (AMED EC)** con:

- Landing Page institucional.
- Sistema Administrativo responsivo.
- Login con JWT.
- Control de permisos por módulo.
- Arquitectura organizada por `hooks`, `context`, `components`, `pages` y `services`.
- Integración visual con utilidades Tailwind (vía CDN) y estilo Material UI-like para componentes base.

## Estructura

```txt
src/
  components/
    admin/
    auth/
    common/
    landing/
    layout/
  context/
  hooks/
  pages/
    admin/
    auth/
    landing/
  services/
  utils/
```

## Ejecución

```bash
npm install
npm run dev
```

## Variables de entorno

Crear `.env` opcional:

```bash
VITE_API_URL=http://localhost:3000/api
```

## Rutas

- `#/` Landing Page
- `#/login` Login administrativo
- `#/admin` Dashboard
- `#/admin/users` Gestión de usuarios
- `#/admin/roles` Gestión de roles

## Módulos iniciales

### 1) Gestión de usuarios

- Listado de usuarios.
- Creación/edición de usuario con rol y estado.
- Restringido por permisos `users.read` y `users.write`.

### 2) Gestión de roles

- Listado de roles.
- Creación de roles con permisos.
- Restringido por permisos `roles.read` y `roles.write`.

## Notas de escalabilidad

- Toda la comunicación HTTP centralizada en `services/httpClient.js`.
- Seguridad desacoplada en `AuthContext` + hooks (`useAuth`, `usePermission`).
- El shell administrativo concentra layout, navegación y guardas de acceso.
