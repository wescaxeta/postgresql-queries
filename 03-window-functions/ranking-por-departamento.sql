-- Ranking de salário dentro de cada departamento usando RANK() e DENSE_RANK().
-- RANK() pula posições em caso de empate; DENSE_RANK() não pula.

SELECT
    f.nome,
    d.nome                                                      AS departamento,
    f.salario,
    RANK()       OVER (PARTITION BY f.departamento_id ORDER BY f.salario DESC) AS rank_com_pulo,
    DENSE_RANK() OVER (PARTITION BY f.departamento_id ORDER BY f.salario DESC) AS rank_sem_pulo,
    ROUND(
        f.salario / AVG(f.salario) OVER (PARTITION BY f.departamento_id) * 100, 1
    )                                                           AS pct_vs_media_depto
FROM funcionarios f
JOIN departamentos d ON d.id = f.departamento_id
WHERE f.ativo = TRUE
ORDER BY d.nome, rank_com_pulo;
