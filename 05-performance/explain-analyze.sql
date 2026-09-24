-- Como usar EXPLAIN ANALYZE para diagnosticar queries lentas.
-- Sempre rode em ambiente de desenvolvimento — ANALYZE executa a query de verdade.

-- Ver o plano estimado (não executa):
EXPLAIN
SELECT f.nome, COUNT(v.id)
FROM funcionarios f
LEFT JOIN ferias v ON v.funcionario_id = f.id
GROUP BY f.id;

-- Ver plano real com tempo de execução (executa a query):
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT f.nome, COUNT(v.id)
FROM funcionarios f
LEFT JOIN ferias v ON v.funcionario_id = f.id
GROUP BY f.id;

-- O que observar no resultado:
-- "Seq Scan"    → leitura sequencial (pode indicar falta de índice)
-- "Index Scan"  → usando índice (bom)
-- "Hash Join"   → join via hash (geralmente eficiente)
-- "rows=X"      → estimativa de linhas (se muito diferente do actual, stats desatualizadas)
-- "actual time" → tempo real de execução
-- Execute ANALYZE <tabela> para atualizar as estatísticas do planner.
