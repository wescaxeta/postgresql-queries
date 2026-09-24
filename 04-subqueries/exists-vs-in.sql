-- EXISTS é mais eficiente que IN quando a subquery retorna muitas linhas,
-- pois para na primeira ocorrência encontrada.

-- Com IN: carrega todos os IDs na memória antes de comparar
SELECT nome
FROM funcionarios
WHERE id IN (
    SELECT funcionario_id FROM ferias WHERE status = 'solicitada'
);

-- Com EXISTS: para ao encontrar a primeira linha — mais eficiente em tabelas grandes
SELECT f.nome
FROM funcionarios f
WHERE EXISTS (
    SELECT 1 FROM ferias v
    WHERE v.funcionario_id = f.id
      AND v.status = 'solicitada'
);

-- NOT EXISTS: funcionários que nunca tiraram férias
SELECT f.nome, f.data_admissao
FROM funcionarios f
WHERE NOT EXISTS (
    SELECT 1 FROM ferias v
    WHERE v.funcionario_id = f.id
);
