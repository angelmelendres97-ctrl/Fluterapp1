# Backend Node.js + Express + PostgreSQL

## Estructura
- `src/config`: variables de entorno y Prisma
- `src/routes`: rutas por módulo
- `src/controllers`: capa HTTP
- `src/services`: reglas de negocio
- `src/middlewares`: auth, roles, errores
- `prisma/schema.prisma`: modelo ORM
- `sql/schema.sql`: script SQL completo

## Endpoints
### Auth
- `POST /api/auth/login`
- `POST /api/auth/refresh`
- `POST /api/auth/logout`

### Usuarios (ADMIN)
- `GET /api/users`
- `POST /api/users`
- `DELETE /api/users/:id`

### Pacientes (ADMIN, DOCTOR, ASSISTANT)
- `GET /api/patients?query=`
- `POST /api/patients`

## Ejecución
```bash
cp .env.example .env
npm install
npm run prisma:generate
npm run dev
```
