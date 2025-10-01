-- Script de criação da tabela moto para Sprint 3 - DevOps & Cloud
-- Repositório: sprint3-devops-cloud

-- Criar tabela moto
CREATE TABLE moto (
    id SERIAL PRIMARY KEY,
    modelo VARCHAR(100) NOT NULL,
    placa VARCHAR(10) UNIQUE NOT NULL
);

-- Inserir registros de exemplo
INSERT INTO moto (modelo, placa) VALUES 
    ('Honda Pop 110i', 'ABC-1234'),
    ('Yamaha Factor 125', 'XYZ-5678');

-- Verificar os registros inseridos
SELECT * FROM moto;
