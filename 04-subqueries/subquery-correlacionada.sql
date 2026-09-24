-- Subquery correlacionada: para cada funcionário, busca a última viagem feita.
-- É correlacionada porque referencia a tabela externa (f.id) dentro da subquery.

SELECT
    f.nome,
    f.cargo,
    (
        SELECT data_viagem
        FROM diarias d
        WHERE d.funcionario_id = f.id
          AND d.status = 'paga'
        ORDER BY data_viagem DESC
        LIMIT 1
    ) AS ultima_viagem,
    (
        SELECT SUM(valor)
        FROM diarias d
        WHERE d.funcionario_id = f.id
          AND d.status = 'paga'
    ) AS total_gasto_viagens
FROM funcionarios f
WHERE f.ativo = TRUE
ORDER BY ultima_viagem DESC NULLS LAST;
