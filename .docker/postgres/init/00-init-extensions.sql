-- Executado automaticamente pela imagem oficial do Postgres na primeira
-- inicialização do volume (docker-entrypoint-initdb.d). Idempotente por
-- natureza do CREATE EXTENSION IF NOT EXISTS.
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
