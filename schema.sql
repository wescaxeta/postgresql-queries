-- Schema de referência usado nos exemplos deste repositório.
-- Execute este arquivo antes de testar as queries.

CREATE TABLE departamentos (
    id         SERIAL PRIMARY KEY,
    nome       VARCHAR(100) NOT NULL,
    uf         CHAR(2)      NOT NULL
);

CREATE TABLE funcionarios (
    id             SERIAL PRIMARY KEY,
    nome           VARCHAR(150) NOT NULL,
    email          VARCHAR(150) UNIQUE NOT NULL,
    cargo          VARCHAR(100) NOT NULL,
    salario        NUMERIC(10,2) NOT NULL,
    data_admissao  DATE NOT NULL,
    departamento_id INT REFERENCES departamentos(id),
    ativo          BOOLEAN DEFAULT TRUE
);

CREATE TABLE ferias (
    id              SERIAL PRIMARY KEY,
    funcionario_id  INT REFERENCES funcionarios(id),
    data_inicio     DATE NOT NULL,
    data_fim        DATE NOT NULL,
    dias            INT NOT NULL,
    status          VARCHAR(20) DEFAULT 'solicitada'
                    CHECK (status IN ('solicitada','aprovada','concluida','cancelada'))
);

CREATE TABLE diarias (
    id              SERIAL PRIMARY KEY,
    funcionario_id  INT REFERENCES funcionarios(id),
    data_viagem     DATE NOT NULL,
    valor           NUMERIC(8,2) NOT NULL,
    com_pernoite    BOOLEAN DEFAULT FALSE,
    status          VARCHAR(20) DEFAULT 'solicitada'
                    CHECK (status IN ('solicitada','aprovada_nucleo','aprovada','paga','rejeitada'))
);

CREATE TABLE afastamentos (
    id              SERIAL PRIMARY KEY,
    funcionario_id  INT REFERENCES funcionarios(id),
    motivo          VARCHAR(50) NOT NULL,
    data_inicio     DATE NOT NULL,
    data_fim        DATE,
    ativo           BOOLEAN DEFAULT TRUE
);
