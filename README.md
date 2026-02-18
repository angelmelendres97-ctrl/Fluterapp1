# Gestión Clínica (Flutter + Node.js)

Aplicación full-stack para autenticación, gestión de usuarios y gestión de pacientes con arquitectura modular y escalable.

## Frontend Flutter
- Arquitectura feature-first por módulos:
  - `features/auth`
  - `features/users`
  - `features/patients`
- Capas por feature:
  - `presentation` (screens/widgets)
  - `application` (state management con Riverpod)
  - `domain` (entidades/repositorios)
  - `data` (modelos + integración API con Dio)
- Enrutamiento centralizado con `go_router`.

## Backend
El backend completo está en `BACKEND/` con Express + Prisma + PostgreSQL.

## Arranque rápido Flutter
```bash
flutter pub get
flutter run
```

## Arranque backend
```bash
cd BACKEND
cp .env.example .env
npm install
npm run prisma:generate
npm run dev
```
