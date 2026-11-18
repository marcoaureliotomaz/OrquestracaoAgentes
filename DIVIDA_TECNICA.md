# Registro de dívida técnica

Use este registro para simplificações conscientes, limitações técnicas e problemas descobertos que não possam ser corrigidos na mesma tarefa. Não registre uma falha de segurança relevante como dívida aceitável para entrega: ela bloqueia a história. Falhas funcionais relevantes e portões obrigatórios de teste também bloqueiam a conclusão.

## Regras

- Abrir um item **no momento em que a dívida é identificada**, com evidência, impacto e tarefa ou história relacionada. Não deixar apenas `TODO` no código ou observação solta em uma resposta.
- Classificar por prioridade: `P0` bloqueia a entrega (segurança ou comportamento essencial); `P1` deve ser resolvida antes da próxima entrega afetada; `P2` pode entrar no planejamento regular com responsável e gatilho de revisão.
- Registrar uma correção pequena imediatamente quando ela estiver dentro do escopo da tarefa atual. A dívida existe para escolhas ou problemas que exigem trabalho adicional real.
- Revisar itens abertos no refinamento de cada história e antes de cada entrega. Ao resolver, vincular a tarefa de correção e a evidência de teste ou medição.
- Se um item crescer ou revelar risco maior, dividir em tarefa pequena e reclassificar. Não usar cobertura alta para justificar dívida em autenticação, autorização ou proteção de dados.

## Itens

### DT-001 — Comando de início de feature falha sem `-Root`

- Origem: F-12 / `scripts/start-feature.ps1`, identificado durante T-001 da F-01.
- Estado: aberto
- Prioridade: P1
- Evidência e impacto: a chamada documentada sem `-Root` falhou no PowerShell ao avaliar `Split-Path -Parent $PSScriptRoot` na lista de parâmetros. O comando com `-Root .` criou a branch corretamente, mas o uso padrão documentado fica indisponível.
- Motivo de não corrigir agora: T-001 restringe-se ao contrato de acesso da F-01; a correção pertence à F-12.
- Responsável: infraestrutura local da F-12.
- Prazo ou gatilho: corrigir antes da próxima feature iniciada pelo comando padrão.
- Plano de correção: calcular a raiz padrão no corpo do script após o binding dos parâmetros e testar a invocação sem `-Root`.
- Verificação de encerramento: teste isolado cria uma branch chamando o script sem `-Root` e o exemplo de `VERSIONAMENTO.md` funciona.

<!-- Modelo para o próximo item:
### DT-001 — Título objetivo
- Origem: H-xx / T-xxx / arquivo e linha
- Estado: aberto | em correção | resolvido
- Prioridade: P0 | P1 | P2
- Evidência e impacto: comportamento observado e consequência
- Motivo de não corrigir agora: decisão concreta, se aplicável
- Responsável: papel ou pessoa
- Prazo ou gatilho: história/entrega/evento verificável
- Plano de correção: menor mudança esperada
- Verificação de encerramento: teste, medição ou revisão
-->
