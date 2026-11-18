# Validação da feature F-xx

Copie este modelo ao concluir uma feature. Preencha um relatório por `F-xx`, sem incluir tokens, credenciais, dados pessoais, links de acesso ou logs sensíveis. Use `não aplicável` somente com justificativa concreta. A decisão permanece `pendente` se faltar evidência obrigatória.

## Identificação

| Campo | Valor |
| --- | --- |
| Feature | F-xx — nome |
| Branch e commit avaliado | `feature/F-xx-descricao` — hash |
| Histórias incluídas | H-xx, H-yy |
| Responsável e data | nome — data |

## Critérios de aceite

Crie uma linha **para cada critério** de cada história da feature. Vincule o resultado a um teste ou a passos manuais reproduzíveis.

| História | Critério | Evidência | Resultado |
| --- | --- | --- | --- |
| H-xx | Critério 1 | Teste/arquivo ou passos e resultado | aprovado / reprovado / não verificado |

## Cobertura de testes

Informe cada módulo de produção alterado e suas métricas. Para Java, linhas e ramos devem atingir 95%; para Angular, linhas, ramos, funções e statements devem atingir 95%. Uma feature sem código executável registra `não aplicável` e explica a verificação dos artefatos.

| Módulo | Comando | Relatório | Métrica | Resultado | Limite | Situação |
| --- | --- | --- | --- | --- | --- | --- |
| Backend/frontend | Comando executado | Caminho do relatório | Linhas/ramos/funções/statements | Percentual | 95% | aprovado / reprovado |

Justificativa de `não aplicável`, se houver: ...

## Testes de integração

Registre cada fronteira afetada e o teste correspondente. Inclua ambiente e resultado. Para feature sem fronteira de integração, explique por que o item não se aplica.

| Fronteira | Comando e ambiente | Evidência | Resultado |
| --- | --- | --- | --- |
| API–banco / frontend–API / outra | Comando, Docker e dependências | Teste ou relatório | aprovado / reprovado / não executado |

Justificativa de `não aplicável`, se houver: ...

## Revisões e decisão

| Verificação | Evidência e resultado |
| --- | --- |
| Segurança e scanner de segredos | Comando, resultado e achados sem valores sensíveis |
| Performance | Cenário, medição ou justificativa de não aplicabilidade |
| QA e dívida técnica | Defeitos, `DIVIDA_TECNICA.md` e pendências |

**Decisão da feature:** aprovada / pendente / reprovada.

**Motivo e pendências:** ...

**Code review humano:** pendente / concluído, com referência à revisão.
