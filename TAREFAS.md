# Tarefas de implementação

As histórias de `BACKLOG.md` descrevem valor para o usuário. Este arquivo é o **índice** das mudanças pequenas de implementação. O resultado, a verificação e o estado de cada tarefa ficam somente em `features/F-xx/tarefas/T-xxx.md`. Tarefas de histórias posteriores são detalhadas quando seus contratos e decisões estiverem disponíveis, para evitar suposições técnicas.

## Regra para uma tarefa estar pronta

Cada tarefa deve ter um identificador, feature e história de origem, um único resultado concreto, componente responsável, entradas ou contrato conhecido, dependências, verificação objetiva e estado. Ela deve caber em uma sessão focada; **até cerca de quatro horas é um sinal prático**, não uma meta de estimativa. Divida a tarefa se atravessar mais de um componente, tiver dois resultados independentes, exigir decisão ainda aberta ou não puder ser verificada isoladamente.

A alteração resultante deve formar um diff pequeno e legível para o code review do usuário. Refatorações sem relação direta com o resultado da tarefa entram em outra tarefa, salvo correção local indispensável.

Toda subtarefa que altera arquivos gera seu próprio commit na branch da feature, conforme `VERSIONAMENTO.md`. O assunto do commit deve trazer a feature e a tarefa. Não agrupe subtarefas no mesmo commit.

Estados: `a fazer`, `pronta`, `em andamento`, `em revisão`, `concluída` ou `bloqueada`. Só `pronta` pode iniciar. Mantenha **uma tarefa de implementação em andamento por agente**. Uma história só termina após integrar as tarefas e passar pelos portões de `QUALIDADE_TESTES.md` e `SEGREDOS.md`.

Não preencha lacunas de requisito ou de contrato por suposição. Marque `bloqueada`, registre a pergunta e continue apenas tarefas independentes. Uma mudança de escopo volta ao `ESCOPO.md` e `BACKLOG.md`; uma simplificação técnica entra em `DIVIDA_TECNICA.md`.

## Próxima história: H-01 — acesso por link de e-mail

As tarefas [T-001](features/F-01/tarefas/T-001.md) a [T-016](features/F-01/tarefas/T-016.md) são um primeiro refinamento. O arquiteto deve fechar o contrato e a estratégia de sessão em T-001 antes de marcar as dependentes como prontas. Nenhuma tarefa implica credenciais reais ou envio de e-mail de produção.

## Próximo refinamento

Após H-01, refinar H-02 e a próxima história selecionada. Não abrir tarefas para todas as histórias com contratos ainda indefinidos.

## Feature técnica F-08 — ambiente local com Docker

| ID | Feature | Resultado único | Responsável | Depende de | Verificação de conclusão | Estado |
| --- | --- | --- | --- | --- | --- | --- |
| T-017 | F-08 | Registrar Docker local como primeira forma de execução e adiar AWS | Arquitetura | H-22 | Escopo, backlog, padrões e arquitetura descrevem a mesma ordem de implementação | concluída |
| T-018 | F-08 | Configurar PostgreSQL e capturador de e-mails com Compose, sem credenciais no projeto | Infraestrutura local | T-017 | `docker compose config --quiet` válido; serviços saudáveis quando o Docker estiver ativo | em revisão |
| T-019 | F-08 | Criar imagem da API Java 17 e adicioná-la ao Compose | Java | T-002, T-018 | API inicia pelo Compose e conecta ao PostgreSQL e SMTP local | bloqueada |
| T-020 | F-08 | Criar imagem do frontend Angular e adicioná-la ao Compose | Angular | frontend criado, T-019 | Interface acessível localmente e chamadas à API funcionam | bloqueada |
| T-021 | F-08 | Verificar jornada local de login por link | QA | T-019, T-020 e H-01 implementada | Jornada reproduzível passa sem AWS nem envio externo de e-mail | bloqueada |

## Feature técnica F-09 — apresentação do repositório

| ID | Feature | Resultado único | Responsável | Depende de | Verificação de conclusão | Estado |
| --- | --- | --- | --- | --- | --- | --- |
| T-022 | F-09 | Escrever README sobre orquestração, escopo, stack e estado real do projeto | Documentação | H-23 | Texto confere com escopo e padrões; links locais existentes | concluída |
| T-023 | F-09 | Criar imagens SVG locais e integrá-las ao README | UI/UX | T-022 | SVGs válidos, legíveis e com texto alternativo no Markdown | concluída |
| T-024 | F-09 | Atualizar o estado do Docker no README após a integração da F-08 | Documentação | T-023, F-08 | Links para Compose e guia local existentes; estado da aplicação preciso | concluída |

## Feature técnica F-10 — validação por feature

| ID | Feature | Resultado único | Responsável | Depende de | Verificação de conclusão | Estado |
| --- | --- | --- | --- | --- | --- | --- |
| T-025 | F-10 | Definir o portão de cobertura, integração e aceite para cada feature | QA | H-24 | Políticas e papéis exigem evidência por feature antes da conclusão | concluída |
| T-026 | F-10 | Criar modelo curto de relatório de validação da feature | QA | T-025 | Modelo permite registrar comandos, métricas, critérios e decisão | concluída |
