-- CreateTable
CREATE TABLE "users" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "roles" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "permissions" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "permissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_role" (
    "userId" INTEGER NOT NULL,
    "roleId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_role_pkey" PRIMARY KEY ("userId","roleId")
);

-- CreateTable
CREATE TABLE "role_permission" (
    "roleId" INTEGER NOT NULL,
    "permissionId" INTEGER NOT NULL,

    CONSTRAINT "role_permission_pkey" PRIMARY KEY ("roleId","permissionId")
);

-- CreateTable
CREATE TABLE "patients" (
    "id" SERIAL NOT NULL,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "document" TEXT NOT NULL,
    "phone" TEXT,
    "email" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "patients_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "roles_name_key" ON "roles"("name");

-- CreateIndex
CREATE UNIQUE INDEX "permissions_code_key" ON "permissions"("code");

-- CreateIndex
CREATE UNIQUE INDEX "patients_document_key" ON "patients"("document");

-- CreateIndex
CREATE INDEX "patients_lastName_idx" ON "patients"("lastName");

-- CreateIndex
CREATE INDEX "patients_document_idx" ON "patients"("document");

-- AddForeignKey
ALTER TABLE "user_role" ADD CONSTRAINT "user_role_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_role" ADD CONSTRAINT "user_role_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "roles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "role_permission" ADD CONSTRAINT "role_permission_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "roles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "role_permission" ADD CONSTRAINT "role_permission_permissionId_fkey" FOREIGN KEY ("permissionId") REFERENCES "permissions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- Seed base roles
INSERT INTO "roles" ("name", "updatedAt") VALUES
  ('admin', NOW()),
  ('medico', NOW()),
  ('asistente', NOW());

-- Seed permissions
INSERT INTO "permissions" ("code", "description", "updatedAt") VALUES
  ('users.read', 'Listar usuarios', NOW()),
  ('users.write', 'Crear y editar usuarios', NOW()),
  ('roles.read', 'Listar roles', NOW()),
  ('roles.write', 'Crear y editar roles', NOW()),
  ('patients.read', 'Listar pacientes', NOW()),
  ('patients.write', 'Crear y editar pacientes', NOW());

-- Seed role-permission mapping
INSERT INTO "role_permission" ("roleId", "permissionId")
SELECT r.id, p.id FROM "roles" r
JOIN "permissions" p ON (
  (r.name = 'admin') OR
  (r.name = 'medico' AND p.code IN ('patients.read', 'patients.write')) OR
  (r.name = 'asistente' AND p.code IN ('patients.read'))
);

-- Seed admin user and role
INSERT INTO "users" ("name", "email", "passwordHash", "active", "updatedAt")
VALUES ('Administrador AMED', 'admin@amedec.com', '$2a$10$RbbCmOqZdY4VaQUZG8QSKOCpbZ7fNPxpqKfWgOpus0MswQeCcC1I.', true, NOW());

INSERT INTO "user_role" ("userId", "roleId")
SELECT u.id, r.id FROM "users" u JOIN "roles" r ON r.name = 'admin' WHERE u.email = 'admin@amedec.com';
