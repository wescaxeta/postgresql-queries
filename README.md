# postgresql-queries

Coleção de queries PostgreSQL organizadas por complexidade e caso de uso.

Baseadas em experiência real com sistema multi-tenant (9 UFs brasileiras) em produção,
cobrindo módulos de RH, relatórios gerenciais e isolamento de dados por estado.

## Estrutura

```
01-joins/
│  ├── filtro-no-on-vs-where.sql       — diferença crítica entre filtrar no ON vs WHERE
│  └── join-com-agregacao.sql          — relatório com múltiplos LEFT JOINs e agregação
02-ctes/
│  ├── saldo-ferias.sql                — cálculo de período aquisitivo com CTE encadeada
│  └── acumulado-mensal.sql            — total mensal com acumulado usando window function
03-window-functions/
│  ├── ranking-por-departamento.sql    — RANK, DENSE_RANK e média por partição
│  └── lead-lag-variacao.sql           — variação mês a mês com LAG()
04-subqueries/
│  ├── exists-vs-in.sql                — quando usar EXISTS ao invés de IN
│  └── subquery-correlacionada.sql     — subquery que referencia a tabela externa
05-performance/
│  ├── explain-analyze.sql             — como ler o plano de execução
│  └── indices.sql                     — índices simples, compostos, parciais e em expressão
06-casos-reais/
│  ├── relatorio-ferias-por-departamento.sql  — relatório gerencial com FILTER
│  ├── multi-tenant-por-uf.sql               — isolamento de dados por estado (RLS + views)
│  └── fluxo-aprovacao.sql                   — funil de status com ARRAY_POSITION
schema.sql                             — schema de referência para rodar os exemplos
```

## Schema

Os exemplos usam um schema de RH simplificado: `funcionarios`, `departamentos`,
`ferias`, `diarias` e `afastamentos`. Execute `schema.sql` para criar as tabelas.

## Conceitos cobertos

| Conceito | Arquivo |
|---|---|
| LEFT JOIN com filtro no ON | `01-joins/filtro-no-on-vs-where.sql` |
| CTE (WITH) encadeada | `02-ctes/saldo-ferias.sql` |
| Window functions (SUM OVER, LAG, RANK) | `02-ctes/acumulado-mensal.sql`, `03-window-functions/` |
| EXISTS vs IN | `04-subqueries/exists-vs-in.sql` |
| EXPLAIN ANALYZE | `05-performance/explain-analyze.sql` |
| Índice parcial | `05-performance/indices.sql` |
| Row Level Security (RLS) | `06-casos-reais/multi-tenant-por-uf.sql` |
| COUNT com FILTER | `06-casos-reais/relatorio-ferias-por-departamento.sql` |
| ARRAY_POSITION para ordenar enum | `06-casos-reais/fluxo-aprovacao.sql` |

## Contexto de origem

Queries desenvolvidas e refinadas em sistema agropecuário multi-tenant com 9 forks
estaduais, onde drift de schema entre UFs e volume de dados exigiam atenção constante
a planos de execução e estratégias de indexação.
