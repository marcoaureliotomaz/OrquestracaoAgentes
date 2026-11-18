# Branches e commits

## Regra de branch

- `main` guarda a base compartilhada. O commit inicial de documentação não pertence a uma feature de produto.
- Cada feature `F-xx` de `BACKLOG.md` recebe **uma branch exclusiva**, criada a partir de `main`: `feature/F-01-acesso-conta`, `feature/F-02-habitos` etc.
- Uma branch de feature contém apenas histórias e tarefas dessa feature. Não misture trabalho de duas features na mesma branch. Se uma mudança compartilhada for necessária, registre-a como tarefa pequena e indique a feature que a introduz; mudanças independentes exigem uma feature técnica própria no backlog.
- Não inicie uma tarefa se a branch atual não corresponder à feature indicada em `TAREFAS.md`.

## Regra de commit

- **Cada subtarefa que altera o projeto gera um commit próprio.** Inclua no mesmo commit sua implementação, testes diretamente relacionados e documentação mínima necessária. Revisões sem alteração de arquivos não exigem commit.
- Um commit deve ter um único objetivo verificável, caber em um diff fácil de ler e referenciar uma tarefa `T-xxx` e sua feature `F-xx`. Se ficar grande, divida a subtarefa antes de commitar.
- Formato do assunto: `tipo(F-xx T-xxx): descrição objetiva`, por exemplo `feat(F-01 T-005): emitir link de acesso com token protegido`. Tipos permitidos: `feat`, `fix`, `test`, `docs`, `refactor` e `chore`.
- Antes do commit, examine o diff preparado, execute a verificação da tarefa e `scripts/scan-secrets.ps1`. Adicione apenas os arquivos da tarefa, em vez de incluir alterações não relacionadas.
- Após uma revisão que exigir correção, crie uma tarefa de correção com novo commit. Preserve a relação entre tarefa e commit; não junte commits de subtarefas diferentes em um único commit.
- A conclusão da feature exige critérios do backlog, portões de `QUALIDADE_TESTES.md`, revisão de segurança, performance e QA, e uma entrega legível para o code review do usuário. A integração em `main` ocorre após esse code review.
- Integre com fast-forward (`git merge --ff-only`) após atualizar a branch da feature com `main`. Preserve os commits por subtarefa no histórico; não faça squash de tarefas diferentes.

## Rastreabilidade

`ESCOPO.md` → `BACKLOG.md` (`F-xx` e `H-xx`) → `TAREFAS.md` (`T-xxx` e `F-xx`) → branch `feature/F-xx-*` → commit com `F-xx T-xxx` no assunto. O hash é obtido pelo histórico Git; não precisa ser escrito no próprio arquivo de tarefas.

O hook `.githooks/commit-msg` valida o nome da branch, a mensagem e a relação tarefa–feature. Ele também executa a verificação de segredos. Configure o repositório local com `git config core.hooksPath .githooks`; a CI deverá repetir as verificações quando existir.
