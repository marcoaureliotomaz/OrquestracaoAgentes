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

## Índice de tarefas

| Tarefa | Feature |
| --- | --- |
| [T-001](features/F-01/tarefas/T-001.md) | [F-01](features/F-01/FEATURE.md) |
| [T-002](features/F-01/tarefas/T-002.md) | [F-01](features/F-01/FEATURE.md) |
| [T-003](features/F-01/tarefas/T-003.md) | [F-01](features/F-01/FEATURE.md) |
| [T-004](features/F-01/tarefas/T-004.md) | [F-01](features/F-01/FEATURE.md) |
| [T-005](features/F-01/tarefas/T-005.md) | [F-01](features/F-01/FEATURE.md) |
| [T-006](features/F-01/tarefas/T-006.md) | [F-01](features/F-01/FEATURE.md) |
| [T-007](features/F-01/tarefas/T-007.md) | [F-01](features/F-01/FEATURE.md) |
| [T-008](features/F-01/tarefas/T-008.md) | [F-01](features/F-01/FEATURE.md) |
| [T-009](features/F-01/tarefas/T-009.md) | [F-01](features/F-01/FEATURE.md) |
| [T-010](features/F-01/tarefas/T-010.md) | [F-01](features/F-01/FEATURE.md) |
| [T-011](features/F-01/tarefas/T-011.md) | [F-01](features/F-01/FEATURE.md) |
| [T-012](features/F-01/tarefas/T-012.md) | [F-01](features/F-01/FEATURE.md) |
| [T-013](features/F-01/tarefas/T-013.md) | [F-01](features/F-01/FEATURE.md) |
| [T-014](features/F-01/tarefas/T-014.md) | [F-01](features/F-01/FEATURE.md) |
| [T-015](features/F-01/tarefas/T-015.md) | [F-01](features/F-01/FEATURE.md) |
| [T-016](features/F-01/tarefas/T-016.md) | [F-01](features/F-01/FEATURE.md) |
| [T-017](features/F-08/tarefas/T-017.md) | [F-08](features/F-08/FEATURE.md) |
| [T-018](features/F-08/tarefas/T-018.md) | [F-08](features/F-08/FEATURE.md) |
| [T-019](features/F-08/tarefas/T-019.md) | [F-08](features/F-08/FEATURE.md) |
| [T-020](features/F-08/tarefas/T-020.md) | [F-08](features/F-08/FEATURE.md) |
| [T-021](features/F-08/tarefas/T-021.md) | [F-08](features/F-08/FEATURE.md) |
| [T-022](features/F-09/tarefas/T-022.md) | [F-09](features/F-09/FEATURE.md) |
| [T-023](features/F-09/tarefas/T-023.md) | [F-09](features/F-09/FEATURE.md) |
| [T-024](features/F-09/tarefas/T-024.md) | [F-09](features/F-09/FEATURE.md) |
| [T-027](features/F-11/tarefas/T-027.md) | [F-11](features/F-11/FEATURE.md) |
| [T-028](features/F-11/tarefas/T-028.md) | [F-11](features/F-11/FEATURE.md) |
| [T-029](features/F-11/tarefas/T-029.md) | [F-11](features/F-11/FEATURE.md) |
| [T-030](features/F-11/tarefas/T-030.md) | [F-11](features/F-11/FEATURE.md) |
| [T-031](features/F-11/tarefas/T-031.md) | [F-11](features/F-11/FEATURE.md) |
