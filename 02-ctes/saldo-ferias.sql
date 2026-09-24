-- Cálculo de saldo de férias por funcionário usando CTE.
-- Cada período aquisitivo = 12 meses = direito a 30 dias.

WITH periodos AS (
    -- Calcula quantos períodos aquisitivos cada funcionário completou
    SELECT
        id,
        nome,
        data_admissao,
        FLOOR(
            EXTRACT(YEAR FROM AGE(CURRENT_DATE, data_admissao)) * 12 +
            EXTRACT(MONTH FROM AGE(CURRENT_DATE, data_admissao))
        ) / 12 AS periodos_completos
    FROM funcionarios
    WHERE ativo = TRUE
),
dias_gozados AS (
    -- Total de dias já tirados por funcionário
    SELECT
        funcionario_id,
        SUM(dias) AS total_gozado
    FROM ferias
    WHERE status IN ('aprovada', 'concluida')
    GROUP BY funcionario_id
)
SELECT
    p.nome,
    p.data_admissao,
    p.periodos_completos,
    (p.periodos_completos * 30)                          AS dias_direito,
    COALESCE(dg.total_gozado, 0)                        AS dias_gozados,
    (p.periodos_completos * 30) - COALESCE(dg.total_gozado, 0) AS saldo
FROM periodos p
LEFT JOIN dias_gozados dg ON dg.funcionario_id = p.id
ORDER BY saldo DESC;
