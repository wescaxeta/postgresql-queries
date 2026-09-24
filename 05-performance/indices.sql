-- Exemplos de índices e quando usá-los.

-- Índice simples: acelera filtros e JOINs por FK
CREATE INDEX idx_ferias_funcionario ON ferias(funcionario_id);
CREATE INDEX idx_diarias_funcionario ON diarias(funcionario_id);

-- Índice composto: útil quando a query filtra por dois campos juntos
-- A ordem importa: coluna com maior seletividade primeiro
CREATE INDEX idx_diarias_funcionario_status ON diarias(funcionario_id, status);

-- Índice parcial: indexa apenas as linhas que satisfazem a condição
-- Muito menor que um índice completo — ideal para status com baixa cardinalidade
CREATE INDEX idx_ferias_solicitadas ON ferias(funcionario_id)
    WHERE status = 'solicitada';

CREATE INDEX idx_funcionarios_ativos ON funcionarios(departamento_id)
    WHERE ativo = TRUE;

-- Índice em expressão: quando o filtro usa função sobre a coluna
CREATE INDEX idx_ferias_ano ON ferias(EXTRACT(YEAR FROM data_inicio));

-- Verificar índices de uma tabela
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'ferias';

-- Verificar índices não utilizados (candidatos a remoção)
SELECT schemaname, tablename, indexname, idx_scan
FROM pg_stat_user_indexes
WHERE idx_scan = 0
ORDER BY tablename;
