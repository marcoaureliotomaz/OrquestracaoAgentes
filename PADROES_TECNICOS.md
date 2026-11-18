# Padrões técnicos da POC

Estas são as escolhas padrão **para a aplicação nova** definida em `ESCOPO.md`. Antes de gerar código, o arquiteto confirma se cada escolha atende à história selecionada; mudanças devem ter motivo registrado. Em um repositório já iniciado, preserve a stack existente salvo decisão explícita de migração. Fixe versões exatas e lockfiles ao criar os módulos; revise compatibilidade e suporte nessa ocasião.

## Stack padrão

| Área | Padrão | Quando usar |
| --- | --- | --- |
| Backend | **Java 17 LTS**, Spring Boot 4.x, Spring Web MVC e Maven | API HTTP e regras de negócio. Compilar com `--release 17` e não usar APIs de versões posteriores. |
| Segurança e login | Spring Security, OAuth2 Client para Google, validação de entradas e Spring Mail para links de acesso | O escopo exige login por Google e link de e-mail. Autorização sempre no servidor; tokens de link são de uso único e expiram. |
| Persistência | PostgreSQL, Spring Data JPA e Flyway | O tracker exige histórico persistente por usuário. Usar migrações versionadas e revisar consultas do calendário. |
| Frontend | Angular 22, TypeScript, Angular Router e HttpClient | Interface web quando prevista no escopo. Usar componentes standalone e recursos reativos nativos; conferir a matriz Node/TypeScript do Angular. |
| UI | HTML semântico, CSS e componentes Angular | Biblioteca visual somente se acelerar o produto sem comprometer acessibilidade, identidade ou peso da aplicação. |
| Infraestrutura | Docker Compose local primeiro; estratégia AWS futura em `ARQUITETURA_AWS_POC.md` | Executar API, frontend, PostgreSQL e capturador de e-mails localmente antes de planejar hospedagem AWS. |
| Testes | JUnit Jupiter, Spring Boot Test, Testcontainers com PostgreSQL e JaCoCo; Angular com Vitest e cobertura; Playwright para jornadas web | Seguir os portões de `QUALIDADE_TESTES.md`; testar integração real com banco, contratos e autorização. |

## Metodologia de trabalho

1. Refinar `ESCOPO.md` em features e histórias pequenas no `BACKLOG.md`, com critérios de aceite verificáveis.
2. Implementar em fatias verticais: uma história deve atravessar as camadas necessárias e produzir comportamento demonstrável.
3. Manter um quadro simples de trabalho: a fazer, em andamento, em revisão e concluído. Limitar trabalho simultâneo quando houver dependências.
4. Usar exemplos de comportamento no formato dado/quando/então para critérios de aceite. Aplicar TDD especialmente a regras de domínio ou correções de defeitos; evitar testes que apenas espelham a implementação.
5. Revisar segurança, depois performance, depois qualidade funcional e experiência. Corrigir achados relevantes antes de encerrar a história.
6. Executar os portões de `QUALIDADE_TESTES.md` na integração contínua; usar cobertura para localizar lacunas, sem substituir testes de comportamento e segurança.

## Arquitetura e código

- Começar com monólito modular para a POC. Separar módulos por capacidade do negócio e definir contratos explícitos entre eles.
- Usar princípios de POO e SOLID para manter coesão, encapsulamento e dependências claras. Preferir composição; criar interfaces para fronteiras e variações reais.
- Separar domínio e casos de uso de HTTP, banco e AWS quando houver regras ou integrações que justifiquem esse isolamento. Não exigir uma arquitetura hexagonal completa para um CRUD simples.
- Registrar decisões arquiteturais relevantes em notas curtas no projeto, incluindo contexto, escolha e consequência.
- Definir métricas de latência, volume e custo a partir do escopo. Otimizar caminhos críticos com medição, preservando controles de segurança.
- Obter credenciais somente de fontes externas seguras; aplicar `SEGREDOS.md` em Java, Angular, AWS, testes e documentação.

## Legibilidade para code review humano

- Cada alteração deve corresponder a uma tarefa de `TAREFAS.md`. Evite misturar funcionalidade, refatoração ampla e mudanças de formatação no mesmo conjunto de alterações.
- Use nomes que revelem intenção e termos consistentes com o domínio. Em código novo, prefira identificadores em inglês e textos exibidos ao usuário em português; siga a convenção existente se o repositório adotar outra.
- Escreva fluxo explícito, métodos e componentes com uma responsabilidade reconhecível. Prefira construções simples a cadeias longas, efeitos colaterais ocultos, abstrações genéricas e soluções compactas difíceis de depurar.
- Comentários devem explicar uma decisão ou regra não evidente. Evite comentar o que o código já diz; registre decisões de arquitetura em nota curta quando afetarem vários módulos.
- Mantenha contratos, erros, validações e fronteiras de autorização fáceis de localizar. Não esconda comportamento essencial em geração de código, reflexão ou convenções implícitas sem necessidade concreta.
- Nomeie testes pelo comportamento que provam e organize dados de teste para que o cenário seja compreendido sem inspecionar a implementação.
- Ao entregar código, informe tarefa e história, resumo por arquivo, motivo de decisões relevantes, comandos e resultados dos testes, riscos e itens de dívida técnica. Nunca inclua segredos ou dados privados nessa apresentação.

## Referências oficiais consultadas

- [Java 17 LTS](https://www.oracle.com/java/technologies/java-se-support-roadmap.html)
- [Requisitos do Spring Boot 4.0](https://docs.spring.io/spring-boot/4.0/system-requirements.html)
- [Spring Security OAuth2 Login](https://docs.spring.io/spring-security/reference/7.0/servlet/oauth2/login/core.html)
- [Envio de e-mail no Spring Boot](https://docs.spring.io/spring-boot/reference/io/email.html)
- [Versões e compatibilidade do Angular](https://angular.dev/reference/versions)
- [Testes no Angular](https://angular.dev/guide/testing)
- [AWS CDK v2 com TypeScript](https://docs.aws.amazon.com/cdk/v2/guide/work-with-cdk-typescript.html)
- [Playwright Test](https://playwright.dev/docs/intro)
- [WCAG 2.2](https://www.w3.org/TR/WCAG22/)
