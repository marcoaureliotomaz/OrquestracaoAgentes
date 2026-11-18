# Orquestração de agentes

Este projeto usa `ESCOPO.md` para definir o produto, `BACKLOG.md` e `TAREFAS.md` como índices, e `features/F-xx/FEATURE.md`, `features/F-xx/historias/H-xx.md` e `features/F-xx/tarefas/T-xxx.md` como fontes de verdade de cada item. `VERSIONAMENTO.md` define branches e commits, `DIVIDA_TECNICA.md` registra pendências técnicas, `PADROES_TECNICOS.md` define a stack, `ARQUITETURA_AWS_POC.md` trata de custos e hospedagem futura, `QUALIDADE_TESTES.md` define os portões de entrega e `SEGREDOS.md` protege credenciais. Os arquivos em `agentes/` são instruções de trabalho. O agente principal coordena as tarefas, lê o arquivo do especialista antes de delegar e consolida a entrega. Arquivos Markdown não iniciam agentes por conta própria.

## Prioridades

Em qualquer decisão, respeite esta ordem:

1. **Segurança:** proteja dados, acessos e execução. Uma falha de segurança relevante bloqueia a entrega.
2. **Performance:** defina metas quando necessário, evite desperdício e valide gargalos com evidência. Não reduza a segurança para ganhar velocidade.
3. **Qualidade:** entregue comportamento correto, código claro, testes úteis e documentação suficiente. Uma entrega com falha funcional relevante também não está pronta.

## Princípios de implementação

- Aplique POO e SOLID onde melhorarem a coesão, o encapsulamento e a capacidade de mudança. Cada módulo deve ter uma responsabilidade clara; dependências devem apontar para contratos estáveis quando isso reduzir acoplamento real.
- Prefira composição a herança para reutilização de comportamento. Mantenha regras de negócio separadas de detalhes de interface, persistência e infraestrutura quando essa separação tiver utilidade concreta.
- Crie interfaces, camadas e padrões para uma necessidade presente de substituição, teste ou isolamento. Evite abstrações especulativas, duplicação desnecessária e classes que apenas repassam chamadas.
- Preserve contratos explícitos entre componentes, nomes claros, tratamento consistente de erros e testes que verifiquem comportamento observável.
- Se algum princípio entrar em conflito com segurança ou performance comprovada, documente a decisão e respeite a ordem de prioridades acima.
- Não grave segredos reais em qualquer parte do projeto. Siga `SEGREDOS.md` e execute `scripts/scan-secrets.ps1` antes de concluir alterações; reporte apenas localização e tipo de achado, nunca o valor.
- Escreva código para revisão humana conforme `PADROES_TECNICOS.md`: alterações pequenas por tarefa, nomes claros, fluxo explícito e testes com intenção legível. Prepare um resumo verificável das mudanças para o code review do usuário.
- Depois de alterar features, histórias ou tarefas, execute `scripts/validate-backlog.ps1` para conferir IDs, vínculos e links dos índices.

## Fluxo

1. Leia o pedido, `ESCOPO.md`, `PADROES_TECNICOS.md`, o estado do repositório e a última rodada em `features/F-xx/PROGRESSO.md` da feature envolvida. Identifique requisitos, restrições e critérios de aceite. Se o escopo ainda estiver incompleto, preencha o que for possível com base no pedido e registre decisões abertas. Use a stack padrão como proposta para um projeto novo e ajuste-a ao escopo antes de gerar código.
2. Use `agentes/analista-produto.md` para transformar o escopo em features e histórias pequenas nos arquivos individuais sob `features/`; mantenha `BACKLOG.md` como índice. Cada história deve ter valor observável e critérios de aceite; registre lacunas do escopo sem inventar decisões de produto.
3. Use `agentes/arquiteto-software.md` para planejar a implementação da próxima história, definir contratos entre componentes e identificar decisões técnicas relevantes. Em mudanças pequenas, faça isso de forma breve.
4. Para telas ou fluxos de interação, use `agentes/especialista-uiux.md` para definir a experiência e os critérios de usabilidade antes de detalhar as tarefas visuais.
5. Use `agentes/refinador-tarefas.md` para dividir somente a próxima história em arquivos `features/F-xx/tarefas/T-xxx.md`, com feature, resultado e verificação explícitos; mantenha `TAREFAS.md` como índice. Não inicie uma tarefa bloqueada ou sem contrato; mantenha uma tarefa de implementação em andamento por agente. Antes de alterar arquivos, confira a branch exclusiva da feature conforme `VERSIONAMENTO.md`.
6. Atribua cada tarefa conforme o escopo: `agentes/especialista-java.md` para backend Java, `agentes/especialista-angular.md` para frontend Angular e `agentes/especialista-aws.md` para infraestrutura ou integração com AWS. Acione apenas os papéis envolvidos. Registre decisões importantes no código ou na documentação adequada.
7. Revise nesta ordem de prioridade: `agentes/revisor-seguranca.md`, `agentes/revisor-performance.md`, `agentes/qa.md`. Revisões independentes podem ocorrer em paralelo, mas a decisão de entrega respeita a ordem de prioridade acima. QA confere os portões de `QUALIDADE_TESTES.md` por história e **consolida cada feature**: cobertura mínima de 95% nos módulos aplicáveis, testes de integração pertinentes e cada critério de aceite verificado, com relatório e resultados reproduzíveis.
8. Corrija os achados relevantes, execute as verificações disponíveis e repita apenas as revisões afetadas pelas correções. Faça um commit pequeno para cada subtarefa concluída, com sua feature e ID no assunto, após conferir diff, testes pertinentes e scanner de segredos. Registre dívida técnica em `DIVIDA_TECNICA.md` conforme suas regras; não use dívida para ignorar portão obrigatório. Informe o que foi verificado e qualquer limite concreto da validação.

Quando houver subagentes disponíveis e o usuário solicitar orquestração, delegue tarefas com escopo, arquivos permitidos e resultado esperado explícitos. Evite que dois agentes editem os mesmos arquivos ao mesmo tempo. Se a execução usar apenas um agente, aplique os papéis sequencialmente.

## Contrato de entrega dos especialistas

Cada especialista deve informar: tarefa e história, resultado, evidências (arquivos, comandos ou medições), decisões relevantes, riscos ou pendências e próximo passo recomendado. Revisores devem classificar achados por gravidade e apontar a localização exata; não criem achados hipotéticos sem ligação com o projeto. O agente principal apresenta a entrega de forma que o usuário possa revisar o código sem reconstruir o contexto da conversa.
