-- Diferença entre filtrar no ON vs WHERE em LEFT JOIN.
-- Filtrar no WHERE transforma o LEFT JOIN em INNER JOIN implicitamente.

-- ERRADO: o WHERE elimina os funcionários sem férias,
-- tornando o LEFT JOIN inútil.
SELECT f.nome, v.data_inicio, v.status
FROM funcionarios f
LEFT JOIN ferias v ON f.id = v.funcionario_id
WHERE v.status = 'aprovada';  -- funcionários sem férias são excluídos aqui

-- CORRETO: o filtro vai no ON, preservando todos os funcionários.
SELECT f.nome, v.data_inicio, v.status
FROM funcionarios f
LEFT JOIN ferias v
       ON f.id = v.funcionario_id
      AND v.status = 'aprovada';  -- só traz férias aprovadas, mas mantém o funcionário
