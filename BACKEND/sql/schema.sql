CREATE TABLE roles (
  id SERIAL PRIMARY KEY,
  name VARCHAR(30) NOT NULL UNIQUE,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMP NULL
);

CREATE TABLE permissions (
  id SERIAL PRIMARY KEY,
  code VARCHAR(100) NOT NULL UNIQUE,
  name VARCHAR(120) NOT NULL,
  role_id INT NOT NULL REFERENCES roles(id),
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMP NULL
);

CREATE TABLE user_role (
  user_id INT NOT NULL REFERENCES users(id),
  role_id INT NOT NULL REFERENCES roles(id),
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  PRIMARY KEY (user_id, role_id)
);

CREATE TABLE patients (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(120) NOT NULL,
  last_name VARCHAR(120) NOT NULL,
  document VARCHAR(50) NOT NULL UNIQUE,
  phone VARCHAR(30) NOT NULL,
  created_by INT NULL REFERENCES users(id),
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMP NULL
);

CREATE TABLE refresh_tokens (
  id SERIAL PRIMARY KEY,
  token TEXT NOT NULL UNIQUE,
  user_id INT NOT NULL REFERENCES users(id),
  expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_users_deleted_at ON users(deleted_at);
CREATE INDEX idx_patients_deleted_at ON patients(deleted_at);
CREATE INDEX idx_patients_document ON patients(document);
CREATE INDEX idx_permissions_role ON permissions(role_id);
CREATE INDEX idx_refresh_tokens_user_id ON refresh_tokens(user_id);

INSERT INTO roles(name) VALUES ('ADMIN'), ('DOCTOR'), ('ASSISTANT');
INSERT INTO permissions(code, name, role_id)
SELECT 'USERS_MANAGE', 'Gestionar usuarios', id FROM roles WHERE name = 'ADMIN';
INSERT INTO permissions(code, name, role_id)
SELECT 'PATIENTS_MANAGE', 'Gestionar pacientes', id FROM roles WHERE name IN ('ADMIN','DOCTOR','ASSISTANT');
