-- Relatório gerencial: situação de férias por departamento.
-- Mostra funcionários com saldo vencido (risco trabalhista).

WITH saldo AS (
    SELECT
        f.id,
        f.nome,
        f.departamento_id,
        f.data_admissao,
        FLOOR(
            EXTRACT(YEAR FROM AGE(CURRENT_DATE, f.data_admissao)) * 12 +
            EXTRACT(MONTH FROM AGE(CURRENT_DATE, f.data_admissao))
        ) / 12 * 30                        AS dias_direito,
        COALESCE(SUM(v.dias), 0)           AS dias_gozados
    FROM funcionarios f
    LEFT JOIN ferias v ON v.funcionario_id = f.id
                      AND v.status IN ('aprovada', 'concluida')
    WHERE f.ativo = TRUE
    GROUP BY f.id, f.nome, f.departamento_id, f.data_admissao
)
SELECT
    d.nome                                          AS departamento,
    d.uf,
    COUNT(s.id)                                     AS total_funcionarios,
    SUM(s.dias_direito - s.dias_gozados)            AS saldo_total_dias,
    COUNT(*) FILTER (
        WHERE (s.dias_direito - s.dias_gozados) > 30
    )                                               AS funcionarios_com_saldo_vencido,
    ROUND(AVG(s.dias_direito - s.dias_gozados), 1) AS media_saldo
FROM saldo s
JOIN departamentos d ON d.id = s.departamento_id
GROUP BY d.id, d.nome, d.uf
ORDER BY funcionarios_com_saldo_vencido DESC, saldo_total_dias DESC;
