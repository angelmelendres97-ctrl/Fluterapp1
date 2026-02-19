-- AMED core expansion based on Database.sql

CREATE TABLE IF NOT EXISTS "provinces" (
    "id" SERIAL NOT NULL,
    "country_code" VARCHAR(2) NOT NULL DEFAULT 'EC',
    "name" TEXT NOT NULL,
    "code" TEXT,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "provinces_pkey" PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "cities" (
    "id" SERIAL NOT NULL,
    "province_id" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "cities_pkey" PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "profile_types" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "active" BOOLEAN NOT NULL DEFAULT true,
    CONSTRAINT "profile_types_pkey" PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "company_types" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "active" BOOLEAN NOT NULL DEFAULT true,
    CONSTRAINT "company_types_pkey" PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "appointment_types" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "active" BOOLEAN NOT NULL DEFAULT true,
    CONSTRAINT "appointment_types_pkey" PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "product_categories" (
    "id" SERIAL NOT NULL,
    "parent_id" INTEGER,
    "code" TEXT,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "active" BOOLEAN NOT NULL DEFAULT true,
    CONSTRAINT "product_categories_pkey" PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "profiles" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER,
    "profile_type_id" INTEGER NOT NULL,
    "photo" TEXT,
    "phone" TEXT,
    "address" TEXT,
    "province_id" INTEGER,
    "city_id" INTEGER,
    "latitude" DECIMAL(10,8),
    "longitude" DECIMAL(11,8),
    "created_at" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "profiles_pkey" PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "companies" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER,
    "company_type_id" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "address" TEXT,
    "province_id" INTEGER,
    "city_id" INTEGER,
    "phone" TEXT,
    "email" TEXT,
    "logo" TEXT,
    "verified" BOOLEAN DEFAULT false,
    "created_at" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "companies_pkey" PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "products" (
    "id" SERIAL NOT NULL,
    "company_id" INTEGER NOT NULL,
    "category_id" INTEGER,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "price" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "stock" INTEGER NOT NULL DEFAULT 0,
    "image" TEXT,
    "active" BOOLEAN DEFAULT true,
    "created_at" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "products_pkey" PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "appointments" (
    "id" SERIAL NOT NULL,
    "patient_id" INTEGER NOT NULL,
    "doctor_id" INTEGER,
    "company_id" INTEGER,
    "appointment_type_id" INTEGER NOT NULL,
    "status" VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    "scheduled_at" TIMESTAMP(3),
    "notes" TEXT,
    "price" DECIMAL(10,2) DEFAULT 0,
    "created_at" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "appointments_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX IF NOT EXISTS "provinces_country_name_uq" ON "provinces"("country_code", "name");
CREATE INDEX IF NOT EXISTS "cities_province_id_idx" ON "cities"("province_id");
CREATE UNIQUE INDEX IF NOT EXISTS "cities_province_name_uq" ON "cities"("province_id", "name");
CREATE UNIQUE INDEX IF NOT EXISTS "profile_types_code_key" ON "profile_types"("code");
CREATE UNIQUE INDEX IF NOT EXISTS "company_types_code_key" ON "company_types"("code");
CREATE UNIQUE INDEX IF NOT EXISTS "appointment_types_code_key" ON "appointment_types"("code");
CREATE UNIQUE INDEX IF NOT EXISTS "product_categories_code_key" ON "product_categories"("code");
CREATE INDEX IF NOT EXISTS "product_categories_parent_id_idx" ON "product_categories"("parent_id");
CREATE UNIQUE INDEX IF NOT EXISTS "profiles_user_id_key" ON "profiles"("user_id");
CREATE INDEX IF NOT EXISTS "profiles_profile_type_id_idx" ON "profiles"("profile_type_id");
CREATE INDEX IF NOT EXISTS "profiles_province_id_idx" ON "profiles"("province_id");
CREATE INDEX IF NOT EXISTS "profiles_city_id_idx" ON "profiles"("city_id");
CREATE INDEX IF NOT EXISTS "companies_company_type_id_idx" ON "companies"("company_type_id");
CREATE INDEX IF NOT EXISTS "companies_province_id_idx" ON "companies"("province_id");
CREATE INDEX IF NOT EXISTS "companies_city_id_idx" ON "companies"("city_id");
CREATE INDEX IF NOT EXISTS "products_company_id_idx" ON "products"("company_id");
CREATE INDEX IF NOT EXISTS "products_category_id_idx" ON "products"("category_id");
CREATE INDEX IF NOT EXISTS "appointments_patient_id_idx" ON "appointments"("patient_id");
CREATE INDEX IF NOT EXISTS "appointments_company_id_idx" ON "appointments"("company_id");
CREATE INDEX IF NOT EXISTS "appointments_type_id_idx" ON "appointments"("appointment_type_id");
CREATE INDEX IF NOT EXISTS "appointments_status_idx" ON "appointments"("status");
CREATE INDEX IF NOT EXISTS "appointments_scheduled_at_idx" ON "appointments"("scheduled_at");

ALTER TABLE "cities" ADD CONSTRAINT "cities_province_id_fkey" FOREIGN KEY ("province_id") REFERENCES "provinces"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "product_categories" ADD CONSTRAINT "product_categories_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "product_categories"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "profiles" ADD CONSTRAINT "profiles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "profiles" ADD CONSTRAINT "profiles_profile_type_id_fkey" FOREIGN KEY ("profile_type_id") REFERENCES "profile_types"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "profiles" ADD CONSTRAINT "profiles_province_id_fkey" FOREIGN KEY ("province_id") REFERENCES "provinces"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "profiles" ADD CONSTRAINT "profiles_city_id_fkey" FOREIGN KEY ("city_id") REFERENCES "cities"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "companies" ADD CONSTRAINT "companies_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "companies" ADD CONSTRAINT "companies_company_type_id_fkey" FOREIGN KEY ("company_type_id") REFERENCES "company_types"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "companies" ADD CONSTRAINT "companies_province_id_fkey" FOREIGN KEY ("province_id") REFERENCES "provinces"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "companies" ADD CONSTRAINT "companies_city_id_fkey" FOREIGN KEY ("city_id") REFERENCES "cities"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "products" ADD CONSTRAINT "products_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "products" ADD CONSTRAINT "products_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "product_categories"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "appointments" ADD CONSTRAINT "appointments_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patients"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "appointments" ADD CONSTRAINT "appointments_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "companies"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "appointments" ADD CONSTRAINT "appointments_appointment_type_id_fkey" FOREIGN KEY ("appointment_type_id") REFERENCES "appointment_types"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

INSERT INTO "profile_types" ("code", "name", "description") VALUES
('ADMIN','Administrador','Control total del sistema'),
('DOCTOR','Médico','Profesional de salud'),
('PATIENT','Paciente','Usuario paciente'),
('COMPANY','Empresa','Clínica/Farmacia/Institución'),
('CALLCENTER','Call Center','Operador de soporte 24/7'),
('STAFF','Staff','Personal interno')
ON CONFLICT ("code") DO NOTHING;

INSERT INTO "company_types" ("code", "name", "description") VALUES
('CLINIC','Clínica','Clínicas privadas'),
('PHARMACY','Farmacia','Farmacias y boticas'),
('LAB','Laboratorio','Laboratorios clínicos'),
('IMAGING','Imagenología','Centros de imagen'),
('SPA','Spa / Estética','Centros estéticos'),
('REHAB','Rehabilitación','Fisioterapia y rehab'),
('HOSPITAL','Hospital','Hospitales'),
('GYM','Gimnasio','Centros deportivos'),
('OTHER','Otro','Otros establecimientos')
ON CONFLICT ("code") DO NOTHING;

INSERT INTO "appointment_types" ("code", "name", "description") VALUES
('PRESENTIAL','Presencial','Cita en consultorio'),
('TELEMEDICINE','Telemedicina','Cita online'),
('HOME','Domicilio','Visita a domicilio'),
('EMERGENCY','Emergencia','Atención prioritaria')
ON CONFLICT ("code") DO NOTHING;

INSERT INTO "product_categories" ("code", "name", "description") VALUES
('MEDICINES','Medicinas','Medicamentos y recetas'),
('DEVICES','Dispositivos','Equipos e insumos médicos'),
('SERVICES','Servicios','Servicios médicos y de salud'),
('LAB_TESTS','Exámenes','Exámenes clínicos'),
('DENTAL','Odontología','Servicios y productos odontológicos'),
('AESTHETIC','Estética','Servicios estéticos')
ON CONFLICT ("code") DO NOTHING;

INSERT INTO "permissions" ("code", "description", "updatedAt") VALUES
('patients.read', 'Listar pacientes', NOW()),
('patients.write', 'Crear y editar pacientes', NOW()),
('appointments.read', 'Listar citas', NOW()),
('appointments.write', 'Crear y editar citas', NOW()),
('catalogs.read', 'Listar catálogos del sistema', NOW()),
('catalogs.write', 'Administrar catálogos del sistema', NOW())
ON CONFLICT ("code") DO NOTHING;

INSERT INTO "role_permission" ("roleId", "permissionId")
SELECT r."id", p."id"
FROM "roles" r
JOIN "permissions" p ON (
  r."name" = 'admin'
  OR (r."name" = 'medico' AND p."code" IN ('patients.read', 'patients.write', 'appointments.read', 'appointments.write', 'catalogs.read'))
  OR (r."name" = 'asistente' AND p."code" IN ('patients.read', 'appointments.read', 'catalogs.read'))
)
ON CONFLICT DO NOTHING;
