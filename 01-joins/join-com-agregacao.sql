-- Relatório de funcionários com total de dias de férias gozados
-- e total gasto em diárias, em uma única query.

SELECT
    f.nome,
    f.cargo,
    d.nome                              AS departamento,
    COUNT(DISTINCT v.id)                AS qtd_ferias,
    COALESCE(SUM(v.dias), 0)            AS total_dias_ferias,
    COALESCE(SUM(di.valor), 0)          AS total_diarias,
    COUNT(DISTINCT di.id)               AS qtd_viagens
FROM funcionarios f
JOIN departamentos d        ON d.id = f.departamento_id
LEFT JOIN ferias v          ON v.funcionario_id = f.id
                           AND v.status = 'concluida'
LEFT JOIN diarias di        ON di.funcionario_id = f.id
                           AND di.status = 'paga'
WHERE f.ativo = TRUE
GROUP BY f.id, f.nome, f.cargo, d.nome
ORDER BY total_dias_ferias DESC;
