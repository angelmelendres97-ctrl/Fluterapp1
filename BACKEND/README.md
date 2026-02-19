# Backend - AMED EC API

API REST con **Node.js + Express + Prisma + PostgreSQL** para módulos administrativos web.

## Estructura

```txt
src/
  config/
  controllers/
  middleware/
  models/
  routes/
  services/
  utils/
prisma/
  migrations/
sql/
```

## Requisitos

- Node.js 18+
- PostgreSQL 14+

## Configuración rápida

1. Variables de entorno:

```bash
cp .env.example .env
```

2. Dependencias:

```bash
npm install
```

3. Migración inicial (estructura + datos base):

```bash
npm run prisma:generate
npm run prisma:migrate
```

> La migración incluye datos de prueba iniciales:
>
> - Rol `admin`.
> - Usuario `admin@amedec.com`.
> - Contraseña: `Admin123*`.
> - Permisos base para usuarios, roles y pacientes.

4. Ejecutar API:

```bash
npm run dev
```

## Endpoints principales

### Auth

- `POST /api/auth/login`
- `POST /api/auth/refresh`
- `POST /api/auth/logout`

### Usuarios

- `GET /api/users` (`users.read`)
- `POST /api/users` (`users.write`)
- `PUT /api/users/:id` (`users.write`)

### Roles

- `GET /api/roles` (`roles.read`)
- `POST /api/roles` (`roles.write`)
- `PUT /api/roles/:id` (`roles.write`)

### Pacientes

- `GET /api/patients` (admin, medico, asistente)
- `GET /api/patients/:id` (admin, medico, asistente)
- `POST /api/patients` (admin, medico)
- `PUT /api/patients/:id` (admin, medico)

## Seguridad implementada

- JWT Access Token y Refresh Token.
- Payload JWT con `roles` y `permissions`.
- Middleware de autenticación, autorización por rol y por permiso.
- Validación de payload con Joi.
- Manejo centralizado de errores.
