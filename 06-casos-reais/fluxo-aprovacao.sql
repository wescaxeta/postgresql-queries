-- Consulta do funil de aprovação: quantas diárias estão em cada etapa do fluxo.
-- Útil para relatórios gerenciais e identificar gargalos no processo.

-- Funil geral
SELECT
    status,
    COUNT(*)            AS quantidade,
    SUM(valor)          AS valor_total,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1
    )                   AS pct_do_total
FROM diarias
GROUP BY status
ORDER BY
    ARRAY_POSITION(
        ARRAY['solicitada','aprovada_nucleo','aprovada','paga','rejeitada'],
        status
    );

-- Diárias paradas há mais de 5 dias sem movimentação (possível gargalo)
SELECT
    f.nome              AS funcionario,
    d.status,
    d.data_viagem,
    d.valor,
    CURRENT_DATE - d.data_viagem AS dias_sem_movimentacao
FROM diarias d
JOIN funcionarios f ON f.id = d.funcionario_id
WHERE d.status NOT IN ('paga', 'rejeitada')
  AND d.data_viagem < CURRENT_DATE - INTERVAL '5 days'
ORDER BY dias_sem_movimentacao DESC;
