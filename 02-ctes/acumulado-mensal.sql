-- Total de diárias pagas por mês com acumulado do ano usando CTE + window function.

WITH mensais AS (
    SELECT
        DATE_TRUNC('month', data_viagem)  AS mes,
        COUNT(*)                          AS qtd_viagens,
        SUM(valor)                        AS total_mes
    FROM diarias
    WHERE status = 'paga'
      AND EXTRACT(YEAR FROM data_viagem) = EXTRACT(YEAR FROM CURRENT_DATE)
    GROUP BY DATE_TRUNC('month', data_viagem)
)
SELECT
    TO_CHAR(mes, 'MM/YYYY')              AS mes,
    qtd_viagens,
    total_mes,
    SUM(total_mes) OVER (ORDER BY mes)  AS acumulado_ano
FROM mensais
ORDER BY mes;
