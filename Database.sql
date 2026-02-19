-- ============================================================
-- AMED EC - Script Base (Catálogos + Core RBAC + Pacientes)
-- PostgreSQL
-- ============================================================
-- Nota: Este script asume que AÚN NO existen las tablas.
-- Si ya existen, comenta las secciones duplicadas o adapta con ALTER.
-- ============================================================

BEGIN;

-- =========================
-- 1) CATÁLOGOS GEOGRÁFICOS
-- =========================
CREATE TABLE provinces (
  id SERIAL PRIMARY KEY,
  country_code VARCHAR(2) NOT NULL DEFAULT 'EC',
  name TEXT NOT NULL,
  code TEXT,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cities (
  id SERIAL PRIMARY KEY,
  province_id INTEGER NOT NULL REFERENCES provinces(id) ON DELETE RESTRICT,
  name TEXT NOT NULL,
  code TEXT,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX provinces_country_name_uq ON provinces(country_code, name);
CREATE INDEX cities_province_id_idx ON cities(province_id);
CREATE UNIQUE INDEX cities_province_name_uq ON cities(province_id, name);

-- =========================
-- 2) CATÁLOGOS DEL SISTEMA
-- =========================
CREATE TABLE profile_types (
  id SERIAL PRIMARY KEY,
  code TEXT NOT NULL UNIQUE,      -- ADMIN, DOCTOR, PATIENT, COMPANY, CALLCENTER, STAFF
  name TEXT NOT NULL,
  description TEXT,
  active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE company_types (
  id SERIAL PRIMARY KEY,
  code TEXT NOT NULL UNIQUE,      -- CLINIC, PHARMACY, LAB, IMAGING, SPA, REHAB, HOSPITAL, GYM, OTHER
  name TEXT NOT NULL,
  description TEXT,
  active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE appointment_types (
  id SERIAL PRIMARY KEY,
  code TEXT NOT NULL UNIQUE,      -- PRESENTIAL, TELEMEDICINE, HOME, EMERGENCY
  name TEXT NOT NULL,
  description TEXT,
  active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE product_categories (
  id SERIAL PRIMARY KEY,
  parent_id INTEGER REFERENCES product_categories(id) ON DELETE SET NULL,
  code TEXT UNIQUE,
  name TEXT NOT NULL,
  description TEXT,
  active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE INDEX product_categories_parent_id_idx ON product_categories(parent_id);

-- =========================
-- 3) SEGURIDAD (RBAC)
-- =========================
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  passwordHash TEXT NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  createdAt TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP(3) NOT NULL,
  deletedAt TIMESTAMP(3)
);

CREATE TABLE roles (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  createdAt TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP(3) NOT NULL,
  deletedAt TIMESTAMP(3)
);

CREATE TABLE permissions (
  id SERIAL PRIMARY KEY,
  code TEXT NOT NULL,
  description TEXT,
  createdAt TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP(3) NOT NULL
);

CREATE TABLE user_role (
  userId INTEGER NOT NULL,
  roleId INTEGER NOT NULL,
  createdAt TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT user_role_pkey PRIMARY KEY (userId, roleId)
);

CREATE TABLE role_permission (
  roleId INTEGER NOT NULL,
  permissionId INTEGER NOT NULL,
  CONSTRAINT role_permission_pkey PRIMARY KEY (roleId, permissionId)
);

CREATE UNIQUE INDEX users_email_key ON users(email);
CREATE UNIQUE INDEX roles_name_key ON roles(name);
CREATE UNIQUE INDEX permissions_code_key ON permissions(code);

ALTER TABLE user_role
  ADD CONSTRAINT user_role_userId_fkey
  FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE user_role
  ADD CONSTRAINT user_role_roleId_fkey
  FOREIGN KEY (roleId) REFERENCES roles(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE role_permission
  ADD CONSTRAINT role_permission_roleId_fkey
  FOREIGN KEY (roleId) REFERENCES roles(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE role_permission
  ADD CONSTRAINT role_permission_permissionId_fkey
  FOREIGN KEY (permissionId) REFERENCES permissions(id) ON DELETE CASCADE ON UPDATE CASCADE;

-- =========================
-- 4) PERFILES (TIPO DE CUENTA)
-- =========================
CREATE TABLE profiles (
  id SERIAL PRIMARY KEY,
  user_id INTEGER UNIQUE REFERENCES users(id) ON DELETE CASCADE,
  profile_type_id INTEGER NOT NULL REFERENCES profile_types(id) ON DELETE RESTRICT,
  photo TEXT,
  phone TEXT,
  address TEXT,
  province_id INTEGER REFERENCES provinces(id) ON DELETE RESTRICT,
  city_id INTEGER REFERENCES cities(id) ON DELETE RESTRICT,
  latitude DECIMAL(10,8),
  longitude DECIMAL(11,8),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX profiles_profile_type_id_idx ON profiles(profile_type_id);
CREATE INDEX profiles_province_id_idx ON profiles(province_id);
CREATE INDEX profiles_city_id_idx ON profiles(city_id);

-- =========================
-- 5) PACIENTES (core actual)
-- =========================
CREATE TABLE patients (
  id SERIAL PRIMARY KEY,
  firstName TEXT NOT NULL,
  lastName TEXT NOT NULL,
  document TEXT NOT NULL,
  phone TEXT,
  email TEXT NOT NULL,
  createdAt TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP(3) NOT NULL,
  deletedAt TIMESTAMP(3)
);

CREATE UNIQUE INDEX patients_document_key ON patients(document);
CREATE INDEX patients_lastName_idx ON patients(lastName);
CREATE INDEX patients_document_idx ON patients(document);

-- =========================
-- 6) EMPRESAS / INSTITUCIONES
-- =========================
CREATE TABLE companies (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
  company_type_id INTEGER NOT NULL REFERENCES company_types(id) ON DELETE RESTRICT,
  name TEXT NOT NULL,
  description TEXT,
  address TEXT,
  province_id INTEGER REFERENCES provinces(id) ON DELETE RESTRICT,
  city_id INTEGER REFERENCES cities(id) ON DELETE RESTRICT,
  phone TEXT,
  email TEXT,
  logo TEXT,
  verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX companies_company_type_id_idx ON companies(company_type_id);
CREATE INDEX companies_province_id_idx ON companies(province_id);
CREATE INDEX companies_city_id_idx ON companies(city_id);

-- =========================
-- 7) PRODUCTOS (Marketplace)
-- =========================
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  company_id INTEGER NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  category_id INTEGER REFERENCES product_categories(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL DEFAULT 0,
  stock INTEGER NOT NULL DEFAULT 0,
  image TEXT,
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX products_company_id_idx ON products(company_id);
CREATE INDEX products_category_id_idx ON products(category_id);

-- =========================
-- 8) CITAS (Appointments)
-- =========================
CREATE TABLE appointments (
  id SERIAL PRIMARY KEY,
  patient_id INTEGER NOT NULL REFERENCES patients(id) ON DELETE RESTRICT,
  doctor_id INTEGER, -- se agregará cuando crees tabla doctors
  company_id INTEGER REFERENCES companies(id) ON DELETE SET NULL,
  appointment_type_id INTEGER NOT NULL REFERENCES appointment_types(id) ON DELETE RESTRICT,
  status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
  scheduled_at TIMESTAMP,
  notes TEXT,
  price DECIMAL(10,2) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX appointments_patient_id_idx ON appointments(patient_id);
CREATE INDEX appointments_company_id_idx ON appointments(company_id);
CREATE INDEX appointments_type_id_idx ON appointments(appointment_type_id);
CREATE INDEX appointments_status_idx ON appointments(status);
CREATE INDEX appointments_scheduled_at_idx ON appointments(scheduled_at);

-- =========================
-- 9) SEEDS BÁSICOS (opcional)
-- =========================
INSERT INTO profile_types (code, name, description) VALUES
('ADMIN','Administrador','Control total del sistema'),
('DOCTOR','Médico','Profesional de salud'),
('PATIENT','Paciente','Usuario paciente'),
('COMPANY','Empresa','Clínica/Farmacia/Institución'),
('CALLCENTER','Call Center','Operador de soporte 24/7'),
('STAFF','Staff','Personal interno')
ON CONFLICT (code) DO NOTHING;

INSERT INTO company_types (code, name, description) VALUES
('CLINIC','Clínica','Clínicas privadas'),
('PHARMACY','Farmacia','Farmacias y boticas'),
('LAB','Laboratorio','Laboratorios clínicos'),
('IMAGING','Imagenología','Centros de imagen'),
('SPA','Spa / Estética','Centros estéticos'),
('REHAB','Rehabilitación','Fisioterapia y rehab'),
('HOSPITAL','Hospital','Hospitales'),
('GYM','Gimnasio','Centros deportivos'),
('OTHER','Otro','Otros establecimientos')
ON CONFLICT (code) DO NOTHING;

INSERT INTO appointment_types (code, name, description) VALUES
('PRESENTIAL','Presencial','Cita en consultorio'),
('TELEMEDICINE','Telemedicina','Cita online'),
('HOME','Domicilio','Visita a domicilio'),
('EMERGENCY','Emergencia','Atención prioritaria')
ON CONFLICT (code) DO NOTHING;

-- Categorías base de ejemplo (ajústalas)
INSERT INTO product_categories (code, name, description) VALUES
('MEDICINES','Medicinas','Medicamentos y recetas'),
('DEVICES','Dispositivos','Equipos e insumos médicos'),
('SERVICES','Servicios','Servicios médicos y de salud'),
('LAB_TESTS','Exámenes','Exámenes clínicos'),
('DENTAL','Odontología','Servicios y productos odontológicos'),
('AESTHETIC','Estética','Servicios estéticos')
ON CONFLICT (code) DO NOTHING;

COMMIT;
