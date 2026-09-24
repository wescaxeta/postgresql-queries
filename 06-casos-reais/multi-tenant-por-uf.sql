-- Consulta multi-tenant: isolar dados por UF com segurança.
-- Padrão comum em sistemas que atendem múltiplos estados com um banco compartilhado.

-- Abordagem 1: filtro explícito por UF em todas as queries
SELECT f.nome, f.cargo, f.salario
FROM funcionarios f
JOIN departamentos d ON d.id = f.departamento_id
WHERE d.uf = 'GO';  -- parâmetro passado pela aplicação via sessão

-- Abordagem 2: view por UF para isolar o acesso
CREATE OR REPLACE VIEW funcionarios_go AS
    SELECT f.*
    FROM funcionarios f
    JOIN departamentos d ON d.id = f.departamento_id
    WHERE d.uf = 'GO';

-- Abordagem 3: Row Level Security (RLS) — mais segura para multi-tenant real
ALTER TABLE departamentos ENABLE ROW LEVEL SECURITY;

CREATE POLICY uf_isolation ON departamentos
    USING (uf = current_setting('app.uf_atual', TRUE));

-- A aplicação define o contexto antes de cada query:
-- SET LOCAL app.uf_atual = 'GO';

-- Relatório comparativo entre UFs (visão centralizada — apenas para admin)
SELECT
    d.uf,
    COUNT(f.id)              AS total_funcionarios,
    ROUND(AVG(f.salario), 2) AS salario_medio,
    SUM(f.salario)           AS folha_total
FROM funcionarios f
JOIN departamentos d ON d.id = f.departamento_id
WHERE f.ativo = TRUE
GROUP BY d.uf
ORDER BY folha_total DESC;
