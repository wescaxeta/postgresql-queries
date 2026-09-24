-- Variação mês a mês do total de diárias pagas usando LAG().
-- LAG() acessa o valor da linha anterior dentro da partição.

WITH mensais AS (
    SELECT
        DATE_TRUNC('month', data_viagem) AS mes,
        SUM(valor)                       AS total
    FROM diarias
    WHERE status = 'paga'
    GROUP BY 1
)
SELECT
    TO_CHAR(mes, 'MM/YYYY')                             AS mes,
    total,
    LAG(total) OVER (ORDER BY mes)                      AS total_mes_anterior,
    total - LAG(total) OVER (ORDER BY mes)              AS variacao_absoluta,
    ROUND(
        (total - LAG(total) OVER (ORDER BY mes))
        / NULLIF(LAG(total) OVER (ORDER BY mes), 0) * 100, 2
    )                                                   AS variacao_pct
FROM mensais
ORDER BY mes;
