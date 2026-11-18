# Backlog do sistema — tracker de hábitos

Derivado de `ESCOPO.md`. Este arquivo é o **índice**: cada feature tem `features/F-xx/FEATURE.md`, e cada história tem `features/F-xx/historias/H-xx.md`. Ordem sugerida para a primeira versão web: segurança e acesso, cadastro, registro rápido, metas e visualização, personalização e compartilhamento. **P0** é necessário para o produto central; **P1** completa a primeira versão descrita no escopo. Os identificadores são estáveis e não definem a ordem de execução; priorize pelas dependências e pelo valor. Histórias são divididas em tarefas pequenas ao entrar na próxima etapa. Uma história só está concluída quando seus critérios e os critérios transversais ao fim deste documento forem verificados.

## Features

| ID | Feature e resultado para o usuário | Escopo | Prioridade |
| --- | --- | --- | --- |
| F-01 | Acesso e conta: entrar com segurança e administrar dados básicos | 3 Conta e acesso; 5; 6 Segurança | P0 |
| F-02 | Catálogo pessoal: criar e organizar vários hábitos | 3 Hábitos e metas; 5 | P0 |
| F-03 | Registro diário: marcar uma execução rapidamente e ver totais corretos | 3 Registro diário; 5 | P0 |
| F-04 | Planejamento: configurar metas diárias, em dias escolhidos ou registro livre | 3 Hábitos e metas; 7.5 | P0 |
| F-05 | Acompanhamento: entender frequência, quantidade, histórico e evolução mensal | 3 Registro diário; 5; 7.4 e 7.12 | P0 |
| F-06 | Experiência e temas: usar bem no celular e escolher aparência | 3 Interface; 6 Qualidade | P0 para uso móvel; P1 para temas |
| F-07 | Compartilhamento: gerar imagem do progresso com controle do usuário | 3 Compartilhamento; 5 | P1 |
| F-08 | Ambiente local: executar e testar a aplicação completa com Docker Compose | 6 Plataforma técnica | P0 técnico |
| F-09 | Apresentação do projeto: explicar a POC, a orquestração de agentes e o estado da implementação | Documentação do repositório | P0 técnico |
| F-10 | Validação por feature: reunir evidências de testes, integração e aceite antes da conclusão | Qualidade do processo | P0 técnico |

## Histórias

| ID | Feature | História |
| --- | --- | --- |
| [H-01](features/F-01/historias/H-01.md) | [F-01](features/F-01/FEATURE.md) | Entrar por link enviado ao e-mail |
| [H-02](features/F-01/historias/H-02.md) | [F-01](features/F-01/FEATURE.md) | Entrar com Google |
| [H-03](features/F-01/historias/H-03.md) | [F-01](features/F-01/FEATURE.md) | Consultar e editar dados básicos |
| [H-04](features/F-02/historias/H-04.md) | [F-02](features/F-02/FEATURE.md) | Criar um hábito pessoal |
| [H-05](features/F-02/historias/H-05.md) | [F-02](features/F-02/FEATURE.md) | Começar com uma sugestão de hábito |
| [H-06](features/F-02/historias/H-06.md) | [F-02](features/F-02/FEATURE.md) | Editar a apresentação de um hábito |
| [H-07](features/F-03/historias/H-07.md) | [F-03](features/F-03/FEATURE.md) | Registrar execução simples com um toque |
| [H-08](features/F-03/historias/H-08.md) | [F-03](features/F-03/FEATURE.md) | Registrar tempo e visualizar horas realizadas |
| [H-09](features/F-03/historias/H-09.md) | [F-03](features/F-03/FEATURE.md) | Registrar distância percorrida |
| [H-10](features/F-04/historias/H-10.md) | [F-04](features/F-04/FEATURE.md) | Planejar meta diária |
| [H-11](features/F-04/historias/H-11.md) | [F-04](features/F-04/FEATURE.md) | Planejar meta em dias escolhidos |
| [H-12](features/F-04/historias/H-12.md) | [F-04](features/F-04/FEATURE.md) | Usar hábito sem meta |
| [H-13](features/F-05/historias/H-13.md) | [F-05](features/F-05/FEATURE.md) | Ver calendário de intensidade por hábito |
| [H-14](features/F-05/historias/H-14.md) | [F-05](features/F-05/FEATURE.md) | Consultar detalhes e totais de um dia |
| [H-15](features/F-03/historias/H-15.md) | [F-03](features/F-03/FEATURE.md) | Registrar realização em um dia anterior |
| [H-16](features/F-03/historias/H-16.md) | [F-03](features/F-03/FEATURE.md) | Corrigir ou excluir um lançamento |
| [H-17](features/F-06/historias/H-17.md) | [F-06](features/F-06/FEATURE.md) | Usar os fluxos principais no celular |
| [H-18](features/F-06/historias/H-18.md) | [F-06](features/F-06/FEATURE.md) | Escolher e preservar tema visual |
| [H-19](features/F-07/historias/H-19.md) | [F-07](features/F-07/FEATURE.md) | Gerar imagem do progresso |
| [H-20](features/F-07/historias/H-20.md) | [F-07](features/F-07/FEATURE.md) | Compartilhar ou salvar a imagem |
| [H-21](features/F-05/historias/H-21.md) | [F-05](features/F-05/FEATURE.md) | Comparar cada hábito com o mês anterior no dashboard |
| [H-22](features/F-08/historias/H-22.md) | [F-08](features/F-08/FEATURE.md) | Executar a aplicação localmente com Docker |
| [H-23](features/F-09/historias/H-23.md) | [F-09](features/F-09/FEATURE.md) | Apresentar a POC no README |
| [H-25](features/F-11/historias/H-25.md) | [F-11](features/F-11/FEATURE.md) | Navegar pelo backlog em arquivos separados |

### H-24 — Validar a conclusão de cada feature

- Feature: F-10; origem: política de qualidade; prioridade: P0 técnico; dependências: `QUALIDADE_TESTES.md` e histórias da feature avaliada.
- História: Como responsável pelo code review, quero ver evidências de cobertura, integração e critérios de aceite para decidir se uma feature está concluída.
- Critérios de aceite:
  1. Cada história da feature tem seus critérios de aceite conferidos com resultado e evidência identificável.
  2. Os módulos de produção alterados têm relatórios de cobertura dentro dos limites exigidos; ausência de código executável é registrada como não aplicável com justificativa.
  3. Os testes de integração pertinentes são executados e seus resultados registrados; impedimentos deixam a feature pendente.
  4. QA publica um resumo por feature com falhas, pendências e decisão de aprovação ou reprovação antes do code review humano.

## Critérios transversais de conclusão

- Toda leitura, criação e alteração de hábitos ou registros exige sessão válida e autorização pelo proprietário no servidor; tentativas cruzadas entre contas são testadas.
- Erros de rede e validação apresentam mensagem recuperável. A interface evita duplicação acidental de registros, mas permite múltiplas execuções deliberadas.
- Ao registrar sem escolher data, usar a data civil no fuso atual do dispositivo. Guardar a data definida naquele momento e preservá-la se o dispositivo mudar de fuso depois. Testar virada de dia e limites de período.
- Telas principais seguem os critérios de responsividade e acessibilidade definidos por UI/UX. Segurança, performance e QA revisam histórias relevantes antes de concluí-las.
- A conclusão de cada história exige os portões aplicáveis de `QUALIDADE_TESTES.md`: cobertura mínima, testes de integração e jornadas relevantes executados com resultado registrado.
- Nenhuma história é concluída com credencial real no projeto. Executar a verificação de `SEGREDOS.md` e revisar configurações, logs e artefatos afetados.

## Decisões em aberto

1. **Paletas (escopo 8):** UI/UX deve propor cores e verificar legibilidade antes de H-18.
2. **Alteração de meta:** definir se mudanças em metas afetam avaliação histórica ou só dias futuros; afeta H-10 e H-11.
3. **Alteração de unidade:** decidir como tratar hábito com registros existentes; afeta H-06.
4. **Vinculação de login:** definir regra segura para um mesmo e-mail verificado usado com link e Google; afeta H-02.
5. **Volume esperado:** estimar quantidade de usuários, hábitos e histórico para definir metas de resposta e validar performance do calendário.
