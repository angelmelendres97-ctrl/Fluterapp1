# Gestión Clínica (Flutter + Node.js)

Proyecto fullstack para gestión de usuarios y pacientes con módulos habilitados por rol.

## Frontend Flutter

Arquitectura **feature-first** con capas por módulo:

- `presentation` (screens/widgets)
- `application` (state management con Riverpod)
- `domain` (entidades y casos de uso)
- `data` (repositorios e integración HTTP con Dio)

Tecnologías:

- Riverpod para estado
- go_router para navegación centralizada
- Dio para consumo API

### Ejecutar frontend

```bash
flutter pub get
flutter run
```

> Puedes apuntar la API con `--dart-define=API_BASE_URL=http://localhost:3000/api`.

## Backend Node.js

El backend se encuentra en `BACKEND/` y expone endpoints REST para auth, usuarios y pacientes.

Ver documentación detallada en [`BACKEND/README.md`](BACKEND/README.md).

## Base de datos

Script SQL completo disponible en `BACKEND/sql/init.sql`.
