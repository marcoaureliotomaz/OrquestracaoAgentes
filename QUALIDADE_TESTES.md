# Política de qualidade e testes

Esta política vale para a aplicação quando o código for criado. Cobertura mede código exercitado; a aprovação também depende dos cenários e resultados abaixo. O mínimo de 95% é requisito do usuário e não deve ser reduzido por decisão técnica ou dívida registrada.

A verificação de segredos definida em `SEGREDOS.md` também é portão de entrega: execute `scripts/scan-secrets.ps1` antes de concluir alterações e como etapa bloqueante da integração contínua quando o pipeline for criado.

## Portões de entrega

1. Compilação, análise estática configurada, testes unitários, testes de integração e testes de interface relevantes devem passar na integração contínua antes de considerar uma história concluída.
2. **Backend:** JaCoCo deve medir ao menos **95% das linhas e 95% dos ramos** de todo o código de produção escrito para a aplicação, incluindo API, segurança, domínio e persistência. Configurar `jacoco:check` para falhar no `mvn verify` abaixo de qualquer um desses limites. Regras de autorização, links de acesso, agregação diária e metas exigem testes explícitos mesmo se a cobertura global estiver acima da meta.
3. **Frontend:** `ng test --coverage` deve medir ao menos **95% de linhas, ramos, funções e statements** do código de produção em `src/app`. Configurar `coverageThresholds` no Angular para falhar abaixo de qualquer limite. Login, registro, edição, calendário e troca de tema exigem testes de interação relevantes.
4. Exclusões de cobertura limitam-se a código gerado, arquivos de bootstrap e configuração sem lógica. Cada exclusão deve ter justificativa registrada e ser revisada pelo QA; não excluir código difícil de testar para alcançar 95%. Não criar testes que apenas executem código sem verificar resultado.
5. Toda correção de defeito reproduzível inclui teste de regressão na camada mais barata que detecta a falha. Uma alteração em contrato, persistência ou autorização exige integração correspondente.
6. Se um portão não puder rodar por dependência externa ou falha do ambiente, a entrega informa o comando, o erro e o risco; não declare aprovação completa.
7. Antes de concluir uma história, conferir `TAREFAS.md` e `DIVIDA_TECNICA.md`: todas as tarefas necessárias devem estar concluídas, achados devem ter destino explícito e nenhum item P0 pode permanecer aberto.

## Camadas de teste

| Camada | Ferramentas padrão | O que verificar |
| --- | --- | --- |
| Java unitário | JUnit Jupiter, suporte do Spring Boot quando necessário | Regras de meta, soma de tempo e km, intensidade por número de lançamentos, comparação mensal por unidade, meses curtos, empate e datas; sem banco ou rede. |
| Java integrado | Spring Boot Test, Testcontainers com PostgreSQL, Maven Failsafe | API HTTP, migrações Flyway, consultas e agregação mensal, transações, autorização por proprietário e persistência de registros múltiplos no mesmo dia. |
| Autenticação integrada | Spring Security Test, capturador de e-mails de teste e provedor Google simulado na fronteira | Link de uso único, expiração, neutralidade da resposta para e-mail existente ou não, sessão e identidade Google sem chamar contas reais. |
| Angular unitário e de componente | Vitest, TestBed | Formulários, estados de erro, interação de registro rápido, calendário, temas e regras de apresentação. |
| Jornada web | Playwright com frontend e backend de teste | Entrar, criar hábito, registrar, editar/excluir lançamento, consultar calendário e compartilhar/salvar imagem em viewport móvel. |
| AWS | `cdk synth` e assertions do AWS CDK | Permissões, exposição pública, criptografia e recursos esperados quando houver infraestrutura. |

## Cenários transversais obrigatórios

- Usuário A não consegue ler nem alterar hábito ou lançamento do usuário B, mesmo chamando a API com identificadores conhecidos.
- Dois lançamentos do mesmo hábito no mesmo dia geram dois registros e total correto; editar ou excluir um recalcula total, meta, quadrado e comparação mensal.
- A comparação mensal usa o total na unidade do hábito e o período até hoje versus o período correspondente anterior; testar abaixo, igual, superando, zero anterior, hábito novo e mês anterior mais curto.
- Tempo e km rejeitam valores inválidos; execução simples conta uma unidade por marcação deliberada.
- Dias de meta e dias livres são avaliados corretamente; mudança de fuso do dispositivo não altera a data já gravada.
- Link de acesso expirado ou reutilizado é recusado; falhas de Google não criam sessão.
- Interface permanece utilizável em viewport móvel e nos cinco temas; foco, rótulos e estados não dependem apenas de cor.

## Relatório de QA por história

Registrar: histórias verificadas, comandos executados, resultados, percentuais de cobertura com escopo medido, testes de integração e jornada executados, defeitos e limites. Segurança tem precedência sobre performance, que tem precedência sobre qualidade geral.

## Referências de ferramentas

- [JaCoCo Maven Plugin](https://www.jacoco.org/jacoco/trunk/doc/maven.html)
- [Spring Boot e Testcontainers](https://docs.spring.io/spring-boot/4.0/reference/testing/testcontainers.html)
- [Cobertura de testes Angular](https://angular.dev/guide/testing/code-coverage)
- [Limites de cobertura JaCoCo](https://www.jacoco.org/jacoco/trunk/doc/check-mojo.html)
- [Testes de aplicações AWS CDK](https://docs.aws.amazon.com/cdk/v2/guide/testing.html)
- [Configuração do Playwright](https://playwright.dev/docs/test-configuration)
