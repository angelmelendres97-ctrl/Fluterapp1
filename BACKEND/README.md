# Backend - Gestión Clínica API

API REST construida con **Node.js + Express + Prisma + PostgreSQL**.

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
```

## Requisitos

- Node.js 18+
- PostgreSQL 14+

## Setup

1. Copiar variables de entorno:

```bash
cp .env.example .env
```

2. Instalar dependencias:

```bash
npm install
```

3. Crear tablas con Prisma o SQL:

```bash
npm run prisma:generate
npm run prisma:migrate
# o ejecutar sql/init.sql en PostgreSQL
```

4. Ejecutar API:

```bash
npm run dev
```

## Endpoints

- `POST /api/auth/login`
- `POST /api/auth/refresh`
- `POST /api/auth/logout`
- `GET /api/users` (admin)
- `POST /api/users` (admin)
- `PUT /api/users/:id` (admin)
- `GET /api/patients` (admin, medico, asistente)
- `GET /api/patients/:id` (admin, medico, asistente)
- `POST /api/patients` (admin, medico)
- `PUT /api/patients/:id` (admin, medico)

## Seguridad implementada

- JWT Access Token y Refresh Token.
- Middleware de autenticación y autorización por rol.
- Validación de payload con Joi.
- Manejo centralizado de errores.
- Logging con morgan + logger básico.
