# Tarefas de implementação

As histórias de `BACKLOG.md` descrevem valor para o usuário. Este arquivo descreve **mudanças pequenas de implementação**, refinadas apenas para a próxima história a executar. Tarefas de histórias posteriores são detalhadas quando seus contratos e decisões estiverem disponíveis, para evitar suposições técnicas.

## Regra para uma tarefa estar pronta

Cada tarefa deve ter um identificador, feature e história de origem, um único resultado concreto, componente responsável, entradas ou contrato conhecido, dependências, verificação objetiva e estado. Ela deve caber em uma sessão focada; **até cerca de quatro horas é um sinal prático**, não uma meta de estimativa. Divida a tarefa se atravessar mais de um componente, tiver dois resultados independentes, exigir decisão ainda aberta ou não puder ser verificada isoladamente.

A alteração resultante deve formar um diff pequeno e legível para o code review do usuário. Refatorações sem relação direta com o resultado da tarefa entram em outra tarefa, salvo correção local indispensável.

Toda subtarefa que altera arquivos gera seu próprio commit na branch da feature, conforme `VERSIONAMENTO.md`. O assunto do commit deve trazer a feature e a tarefa. Não agrupe subtarefas no mesmo commit.

Estados: `a fazer`, `pronta`, `em andamento`, `em revisão`, `concluída` ou `bloqueada`. Só `pronta` pode iniciar. Mantenha **uma tarefa de implementação em andamento por agente**. Uma história só termina após integrar as tarefas e passar pelos portões de `QUALIDADE_TESTES.md` e `SEGREDOS.md`.

Não preencha lacunas de requisito ou de contrato por suposição. Marque `bloqueada`, registre a pergunta e continue apenas tarefas independentes. Uma mudança de escopo volta ao `ESCOPO.md` e `BACKLOG.md`; uma simplificação técnica entra em `DIVIDA_TECNICA.md`.

## Próxima história: H-01 — acesso por link de e-mail

As tarefas abaixo são um primeiro refinamento. O arquiteto deve fechar o contrato e a estratégia de sessão em T-001 antes de marcar as dependentes como prontas. Nenhuma tarefa implica credenciais reais ou envio de e-mail de produção.

| ID | Feature | Resultado único | Responsável | Depende de | Verificação de conclusão | Estado |
| --- | --- | --- | --- | --- | --- | --- |
| T-001 | F-01 | Definir contrato de solicitação e consumo do link, estados de erro e sessão | Arquitetura | H-01 | Contrato documentado e revisado quanto a enumeração, expiração e uso único | pronta |
| T-002 | F-01 | Criar estrutura mínima do backend Java 17 e build Maven | Java | T-001 | `mvn verify` executa com Java 17 e teste inicial útil | a fazer |
| T-003 | F-01 | Criar migração da conta e teste da migração | Java | T-002 | PostgreSQL Testcontainers aplica a migração sem erro | a fazer |
| T-004 | F-01 | Criar migração para hash e validade de links de acesso | Java | T-003 | Teste integrado confirma estrutura e restrições esperadas | a fazer |
| T-005 | F-01 | Implementar emissão de token de uso único, guardando só seu hash | Java | T-004 | Testes verificam validade, aleatoriedade e ausência de token puro no banco | a fazer |
| T-006 | F-01 | Implementar consumo atômico e expiração do link | Java | T-005 | Testes impedem reutilização e consumo de link expirado | a fazer |
| T-007 | F-01 | Implementar adaptador de envio de e-mail com configuração externa | Java | T-005 | Teste captura mensagem sem serviço real nem segredo no projeto | a fazer |
| T-008 | F-01 | Expor solicitação do link com resposta neutra | Java | T-001, T-007 | Teste HTTP confirma mesma resposta pública para conta existente ou nova | a fazer |
| T-009 | F-01 | Limitar abuso de solicitações de link | Java | T-008 | Teste demonstra bloqueio de excesso sem revelar existência da conta | a fazer |
| T-010 | F-01 | Expor consumo do link e abertura de sessão | Java | T-001, T-006 | Teste HTTP integrado confirma sessão válida e recusa de replay | a fazer |
| T-011 | F-01 | Criar tela móvel para solicitar link e mostrar feedback | Angular | T-001, T-008 e critérios de UI/UX | Teste de componente verifica entrada, carregamento, sucesso e erro | a fazer |
| T-012 | F-01 | Criar fluxo de retorno do link no frontend | Angular | T-001, T-010 e critérios de UI/UX | Teste de componente verifica sucesso, expiração e falha | a fazer |
| T-013 | F-01 | Testar integração do fluxo de link com banco e e-mail capturado | Java | T-008, T-010 | Teste integrado passa com PostgreSQL e sem serviço de e-mail real | a fazer |
| T-014 | F-01 | Revisar os casos de abuso e isolamento do login | Segurança | T-009, T-010, T-013 | Testes comprovam expiração, replay, resposta neutra e limites de solicitação | a fazer |
| T-015 | F-01 | Verificar login em viewport móvel | QA | T-011, T-012 | Jornada Playwright passa em ambiente de teste | a fazer |
| T-016 | F-01 | Conferir os portões de entrega da história | QA | T-013, T-014, T-015 | Cobertura, testes, scanner de segredos e pendências registrados | a fazer |

## Próximo refinamento

Após H-01, refinar H-02 e a próxima história selecionada. Não abrir tarefas para todas as histórias com contratos ainda indefinidos.

## Feature técnica F-09 — apresentação do repositório

| ID | Feature | Resultado único | Responsável | Depende de | Verificação de conclusão | Estado |
| --- | --- | --- | --- | --- | --- | --- |
| T-022 | F-09 | Escrever README sobre orquestração, escopo, stack e estado real do projeto | Documentação | H-23 | Texto confere com escopo e padrões; links locais existentes | concluída |
| T-023 | F-09 | Criar imagens SVG locais e integrá-las ao README | UI/UX | T-022 | SVGs válidos, legíveis e com texto alternativo no Markdown | pronta |
