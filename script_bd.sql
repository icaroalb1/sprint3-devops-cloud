-- =====================================================
-- Script de criação da tabela moto para Sprint 3 - DevOps & Cloud
-- Sistema de Gestão de Frota - Mottu API
-- Repositório: sprint3-devops-cloud
-- =====================================================

-- Criar tabela moto com campos essenciais para gestão de frota
CREATE TABLE moto (
    id SERIAL PRIMARY KEY,                    -- Chave primária auto-incremento
    placa VARCHAR(20) UNIQUE NOT NULL,        -- Placa única da moto (formato brasileiro)
    modelo VARCHAR(100) NOT NULL,             -- Modelo da moto (ex: Honda CG 160)
    status VARCHAR(32) DEFAULT 'DISPONIVEL',  -- Status: DISPONIVEL, EM_USO, EM_MANUTENCAO
    ligada BOOLEAN DEFAULT FALSE,             -- Indica se a moto está ligada
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Data de cadastro no sistema
);

-- Comentários adicionais na tabela
COMMENT ON TABLE moto IS 'Tabela principal para gestão da frota de motos da Mottu';
COMMENT ON COLUMN moto.id IS 'Identificador único da moto';
COMMENT ON COLUMN moto.placa IS 'Placa da moto (formato brasileiro)';
COMMENT ON COLUMN moto.modelo IS 'Modelo e marca da moto';
COMMENT ON COLUMN moto.status IS 'Status atual da moto no sistema';
COMMENT ON COLUMN moto.ligada IS 'Indica se a moto está ligada no momento';
COMMENT ON COLUMN moto.data_cadastro IS 'Data e hora do cadastro no sistema';

-- Inserir registros reais de exemplo para demonstração
INSERT INTO moto (placa, modelo, status, ligada) VALUES 
    ('ABC1D23', 'Honda CG 160', 'DISPONIVEL', false),
    ('XYZ9K87', 'Yamaha Fazer 250', 'EM_USO', true);

-- Verificar os registros inseridos
SELECT * FROM moto;

-- Estatísticas da tabela
SELECT 
    COUNT(*) as total_motos,
    COUNT(CASE WHEN status = 'DISPONIVEL' THEN 1 END) as motos_disponiveis,
    COUNT(CASE WHEN status = 'EM_USO' THEN 1 END) as motos_em_uso,
    COUNT(CASE WHEN status = 'EM_MANUTENCAO' THEN 1 END) as motos_manutencao
FROM moto;
