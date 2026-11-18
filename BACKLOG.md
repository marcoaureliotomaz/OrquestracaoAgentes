# Backlog do sistema — tracker de hábitos

Derivado de `ESCOPO.md`. Ordem sugerida para a primeira versão web: segurança e acesso, cadastro, registro rápido, metas e visualização, personalização e compartilhamento. **P0** é necessário para o produto central; **P1** completa a primeira versão descrita no escopo. Os identificadores são estáveis e não definem a ordem de execução; priorize pelas dependências e pelo valor. Histórias são divididas em tarefas pequenas em `TAREFAS.md` somente quando entram na próxima etapa. Uma história só está concluída quando seus critérios e os critérios transversais ao fim deste documento forem verificados.

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

## Histórias

### H-01 — Entrar por link enviado ao e-mail

- Feature: F-01; origem: seções 3 Conta e acesso, 4 e 6 Segurança; prioridade: P0; dependências: nenhuma.
- História: Como pessoa usuária, quero receber um link no meu e-mail para entrar sem criar senha.
- Critérios de aceite:
  1. Dado um endereço válido, quando peço acesso, então recebo uma mensagem neutra na tela e um link que permite entrar na conta correspondente.
  2. Dado um link expirado ou já utilizado, quando tento entrar, então o acesso é recusado e posso pedir um novo link.
  3. Dado um endereço não cadastrado, quando peço acesso, então a resposta pública não revela se a conta existe.
- Risco: abuso do envio de links e tomada de conta; expiração, uso único e limitação de tentativas são obrigatórios.

### H-02 — Entrar com Google

- Feature: F-01; origem: seções 3 Conta e acesso e 6 Segurança; prioridade: P0; dependências: nenhuma. Reutilizar o modelo de conta e sessão de H-01 sem exigir login por e-mail para quem usa Google.
- História: Como pessoa usuária, quero acessar minha conta com Google para não precisar de outro método de entrada.
- Critérios de aceite:
  1. Dado que autorizo o acesso pelo Google, quando retorno ao sistema, então entro na conta vinculada à minha identidade verificada.
  2. Dado que cancelo ou a autenticação falha, quando retorno ao sistema, então não obtenho sessão e vejo erro recuperável.
- Risco: vinculação indevida de identidades. Definir política segura para mesmo e-mail usado nos dois métodos antes de implementar.

### H-03 — Consultar e editar dados básicos

- Feature: F-01; origem: seção 3 Conta e acesso; prioridade: P1; dependências: H-01 ou H-02 para acesso autenticado.
- História: Como pessoa usuária autenticada, quero ver e alterar meus dados básicos para manter minha conta atualizada.
- Critérios de aceite:
  1. Dado que estou autenticado, quando abro meu perfil, então vejo meu nome de exibição e e-mail.
  2. Dado um novo nome válido, quando salvo, então o nome atualizado aparece no perfil sem afetar hábitos ou registros.
  3. Dado um novo e-mail, quando solicito a mudança, então o endereço só passa a valer após a verificação do novo e-mail.
- Risco: alteração não verificada de e-mail pode transferir o acesso à conta.

### H-04 — Criar um hábito pessoal

- Feature: F-02; origem: seções 3 Hábitos e metas e 5; prioridade: P0; dependências: H-01 ou H-02 para acesso autenticado.
- História: Como pessoa usuária, quero criar vários hábitos com nome, categoria, unidade, cor e ícone opcional para acompanhá-los separadamente.
- Critérios de aceite:
  1. Dado que estou autenticado, quando salvo um hábito válido, então ele aparece na minha lista com nome, categoria, unidade e cor escolhidos.
  2. Dado que não escolho ícone, quando salvo, então o hábito continua válido e recebe apresentação legível.
  3. Dado que tento acessar um hábito de outra conta, quando faço a solicitação, então não vejo nem altero seus dados.
- Observação: o primeiro incremento pode criar o hábito em modo livre; os demais formatos de meta vêm em H-08 e H-09.

### H-05 — Começar com uma sugestão de hábito

- Feature: F-02; origem: seção 3 Hábitos e metas; prioridade: P1; dependências: H-04.
- História: Como pessoa usuária, quero escolher sugestões como ler, estudar, musculação ou correr para cadastrar um hábito mais rápido.
- Critérios de aceite:
  1. Dado o cadastro aberto, quando seleciono uma sugestão, então os campos sugeridos são preenchidos e posso ajustá-los antes de salvar.
  2. Dado que nenhuma sugestão atende à minha necessidade, quando digito um nome próprio, então consigo criar meu hábito normalmente.
- Observação: sugestões não restringem categoria nem unidade final escolhida pelo usuário.

### H-06 — Editar a apresentação de um hábito

- Feature: F-02; origem: seções 3 Hábitos e metas e 5; prioridade: P1; dependências: H-04.
- História: Como pessoa usuária, quero alterar nome, categoria, cor e ícone do meu hábito sem perder o histórico.
- Critérios de aceite:
  1. Dado um hábito meu com registros, quando altero seus dados de apresentação, então o hábito atualizado mantém todos os registros.
  2. Dado um hábito de outra conta, quando tento editá-lo, então a operação é negada.
- Decisão: mudança da unidade de medida após haver registros exige regra própria; não converter histórico silenciosamente.

### H-07 — Registrar execução simples com um toque

- Feature: F-03; origem: seções 2, 3 Registro diário e 5; prioridade: P0; dependências: H-04.
- História: Como pessoa usuária, quero marcar rapidamente uma realização de um hábito simples para manter meu histórico diário.
- Critérios de aceite:
  1. Dado um hábito do tipo execução simples, quando toco em registrar, então um lançamento de uma unidade é salvo para o dia e recebo confirmação clara.
  2. Dado o mesmo hábito e dia, quando marco novamente, então existem dois lançamentos e o total diário é dois.
  3. Dado um hábito de outra conta, quando tento registrá-lo, então a operação é negada.
- Risco: toques repetidos por atraso de rede podem gerar lançamento não intencional; a interface deve evitar duplicação acidental sem impedir múltiplas execuções deliberadas.

### H-08 — Registrar tempo e visualizar horas realizadas

- Feature: F-03; origem: seções 3 Registro diário, 5 e 7.2; prioridade: P0; dependências: H-04.
- História: Como pessoa usuária, quero informar a duração de cada sessão para saber quanto tempo dediquei ao hábito naquele dia.
- Critérios de aceite:
  1. Dado um hábito medido em tempo, quando registro uma duração positiva em horas e minutos, então ela é salva e aparece na unidade correta.
  2. Dado dois lançamentos de 1 h 15 min e 45 min no mesmo dia, quando consulto o total, então vejo 2 h e os dois lançamentos continuam disponíveis.
  3. Dado tempo vazio, zero ou negativo, quando tento salvar, então recebo erro claro e nenhum lançamento é criado.

### H-09 — Registrar distância percorrida

- Feature: F-03; origem: seções 3 Registro diário, 5 e 7.3; prioridade: P0; dependências: H-04.
- História: Como pessoa usuária, quero informar quilômetros percorridos para acompanhar hábitos como correr.
- Critérios de aceite:
  1. Dado um hábito medido em km, quando registro uma distância positiva, então vejo o lançamento e o total diário em km.
  2. Dado dois lançamentos no mesmo dia, quando consulto o total, então vejo a soma sem arredondamento que altere o valor registrado.
  3. Dado valor inválido ou unidade incompatível, quando tento salvar, então nenhum lançamento é criado.

### H-10 — Planejar meta diária

- Feature: F-04; origem: seções 3 Hábitos e metas e 7.5; prioridade: P0; dependências: H-04, H-07, H-08 e H-09 para validar todas as unidades.
- História: Como pessoa usuária, quero definir uma quantidade alvo para todos os dias para acompanhar minha consistência.
- Critérios de aceite:
  1. Dado um hábito com meta diária, quando registro quantidade suficiente no dia, então esse dia aparece como meta atingida.
  2. Dado um dia sem registros, quando consulto a meta, então vejo que ela não foi atingida, sem criar lançamento fictício.
  3. Dado uma meta, quando a altero, então os registros existentes permanecem preservados.
- Decisão: definir se metas alteradas recalculam dias anteriores ou passam a valer apenas a partir da mudança antes da implementação.

### H-11 — Planejar meta em dias escolhidos

- Feature: F-04; origem: seções 3 Hábitos e metas e 7.5; prioridade: P0; dependências: H-10.
- História: Como pessoa usuária, quero escolher dias da semana e uma quantidade alvo por dia para adaptar o plano à minha rotina.
- Critérios de aceite:
  1. Dado meta de estudar 2 h de segunda a sexta, quando consulto sábado, então ele aparece sem meta e não como atraso.
  2. Dado um dia programado, quando o total registrado alcança a quantidade alvo, então a meta do dia aparece como atingida.
  3. Dado um dia não programado, quando registro atividade, então o registro entra no histórico sem transformar o dia em atraso.

### H-12 — Usar hábito sem meta

- Feature: F-04; origem: seções 3 Hábitos e metas e 7.5; prioridade: P0; dependências: H-04, H-07.
- História: Como pessoa usuária, quero manter um hábito em registro livre para acompanhar sua prática sem cobrança diária.
- Critérios de aceite:
  1. Dado um hábito livre, quando não o realizo em um dia, então o dia não aparece como meta descumprida.
  2. Dado um hábito livre, quando registro uma ou mais execuções, então vejo o histórico e os totais normalmente.

### H-13 — Ver calendário de intensidade por hábito

- Feature: F-05; origem: seções 3 Registro diário, 5 e 7.4; prioridade: P0; dependências: H-07, H-08 ou H-09.
- História: Como pessoa usuária, quero um calendário de quadrados para reconhecer os dias em que pratiquei cada hábito.
- Critérios de aceite:
  1. Dado um dia com três lançamentos e outro com um, quando abro o calendário do hábito, então o primeiro quadrado tem intensidade maior, mesmo que o segundo tenha mais horas ou km.
  2. Dado um dia sem lançamento, quando consulto o calendário, então ele é distinguível de um dia com lançamento sem depender só da cor.
  3. Dado muitos dias de histórico, quando mudo o período exibido, então vejo os dias corretos sem precisar carregar todo o histórico da conta.
- Decisão de UI/UX: número de níveis de intensidade e legenda.

### H-14 — Consultar detalhes e totais de um dia

- Feature: F-05; origem: seções 3 Registro diário e 5; prioridade: P0; dependências: H-13.
- História: Como pessoa usuária, quero abrir um dia do calendário para entender quantas vezes pratiquei e qual foi o volume total.
- Critérios de aceite:
  1. Dado um dia com dois lançamentos de tempo, quando o seleciono, então vejo a contagem de dois, cada duração e o total diário em horas e minutos.
  2. Dado um dia sem lançamento, quando o seleciono, então vejo estado vazio claro e nenhuma quantidade inventada.
  3. Dado outro usuário, quando tento consultar detalhes de um hábito que não é meu, então o acesso é negado.

### H-15 — Registrar realização em um dia anterior

- Feature: F-03; origem: seções 3 Registro diário e 5; prioridade: P0; dependências: H-07, H-08 e H-09.
- História: Como pessoa usuária, quero registrar um hábito realizado em um dia anterior para manter meu histórico correto.
- Critérios de aceite:
  1. Dado um hábito meu, quando seleciono uma data anterior e registro uma quantidade válida, então o lançamento aparece nesse dia e os totais desse dia são atualizados.
  2. Dado um hábito de outra conta ou uma data inválida, quando tento registrar, então a operação é recusada sem alterar o histórico.
- Observação: a data escolhida deve ser preservada mesmo se o dispositivo mudar de fuso depois.

### H-16 — Corrigir ou excluir um lançamento

- Feature: F-03; origem: seções 3 Registro diário e 5; prioridade: P0; dependências: H-14, H-15.
- História: Como pessoa usuária, quero corrigir ou excluir um lançamento próprio feito por engano para que meus totais e calendário reflitam o que realmente fiz.
- Critérios de aceite:
  1. Dado um lançamento meu em dia atual ou passado, quando altero sua quantidade para um valor válido, então o detalhe, o total e o calendário desse dia são recalculados.
  2. Dado um lançamento meu, quando confirmo sua exclusão, então ele deixa de compor o detalhe, o total e a intensidade do dia.
  3. Dado um lançamento de outra conta, quando tento editá-lo ou excluí-lo, então a operação é negada.

### H-17 — Usar os fluxos principais no celular

- Feature: F-06; origem: seções 1, 3 Interface e 6 Qualidade; prioridade: P0; dependências: H-04, H-07, H-08, H-09 e H-13 para validar as jornadas principais.
- História: Como pessoa usuária no celular, quero criar, registrar e consultar hábitos sem depender de uma tela grande.
- Critérios de aceite:
  1. Dado um navegador em largura de celular, quando crio e registro um hábito, então os controles permanecem visíveis e operáveis sem rolagem horizontal.
  2. Dado uso por teclado ou tecnologia assistiva, quando percorro os controles principais, então foco, rótulos e feedback são perceptíveis.
- Observação: esta história valida as jornadas e não substitui critérios responsivos em cada tela.

### H-18 — Escolher e preservar tema visual

- Feature: F-06; origem: seções 3 Interface, 5 e 7.7; prioridade: P1; dependências: H-01 e H-17.
- História: Como pessoa usuária, quero escolher entre os temas claro, escuro, militar, feminino e neutro para usar o sistema com aparência confortável.
- Critérios de aceite:
  1. Dado que seleciono um dos cinco temas, quando navego pelas telas, então a aparência é consistente e a escolha é mantida na minha conta.
  2. Dado qualquer tema, quando vejo hábitos e estados de progresso, então textos e controles permanecem legíveis, e o estado não depende somente da cor.
- Decisão de UI/UX: paletas exatas e tratamento da cor individual dos hábitos em cada tema.

### H-19 — Gerar imagem do progresso

- Feature: F-07; origem: seções 3 Compartilhamento, 5 e 7.8; prioridade: P1; dependências: H-13, H-14.
- História: Como pessoa usuária, quero gerar uma imagem simples do meu progresso para compartilhá-la quando desejar.
- Critérios de aceite:
  1. Dado um período e conteúdo selecionados, quando peço a imagem, então vejo prévia legível antes de salvar ou compartilhar.
  2. Dado a imagem gerada, quando a examino, então ela não contém e-mail, identificadores internos nem dados de outros usuários.
  3. Dado que escolho um hábito, quando gero a imagem, então ela mostra só esse hábito; dado que escolho resumo, então ela agrega apenas os meus hábitos.

### H-20 — Compartilhar ou salvar a imagem

- Feature: F-07; origem: seções 2, 3 Compartilhamento e 7.8; prioridade: P1; dependências: H-19.
- História: Como pessoa usuária, quero enviar a imagem por recursos disponíveis no dispositivo ou salvá-la para compartilhar depois.
- Critérios de aceite:
  1. Dado navegador com compartilhamento de arquivos, quando escolho compartilhar, então o sistema abre a ação do dispositivo somente após minha confirmação.
  2. Dado navegador sem esse recurso, quando escolho salvar, então recebo a imagem em arquivo sem publicação automática.

### H-21 — Comparar cada hábito com o mês anterior no dashboard

- Feature: F-05; origem: seções 3 Registro diário, 5 e 7.12; prioridade: P0; dependências: H-04, H-07, H-08, H-09 e H-14. A atualização após correção de lançamentos depende também de H-16.
- História: Como pessoa usuária, quero ver em cada hábito se realizei menos, o mesmo ou mais que no período equivalente do mês anterior para entender minha evolução rapidamente.
- Critérios de aceite:
  1. Dado um hábito de tempo com 2 h no mês atual até hoje e 1 h no mesmo período anterior, quando abro o dashboard, então vejo **Superando**, os dois totais em horas e os períodos comparados.
  2. Dado um hábito de km ou de execução simples, quando o total atual é menor ou igual ao anterior, então vejo respectivamente **Abaixo** ou **Igual**, na unidade correta e sem usar o número de registros para decidir.
  3. Dado um mês anterior mais curto, quando o dia atual não existe nele, então a comparação anterior termina no último dia daquele mês e as datas exibidas deixam isso claro.
  4. Dado um hábito criado no mês atual, quando abro o dashboard, então vejo **Sem histórico anterior**. Se o hábito já existia e o período anterior teve zero lançamentos, esse zero participa da comparação.
  5. Dado um lançamento corrigido ou excluído em um dos períodos, quando volto ao dashboard, então o indicador e os totais refletem a alteração.
  6. Dado outro usuário, quando tento obter os indicadores de seus hábitos, então não recebo seus totais.
- Observação: UI/UX deve mostrar texto e números, sem depender só de cor. O backend deve agregar os hábitos do período sem carregar todo o histórico nem criar consultas por hábito.

### H-22 — Executar a aplicação localmente com Docker

- Feature: F-08; origem: seção 6 Plataforma técnica; prioridade: P0 técnico; dependências: código do backend e frontend para a execução completa.
- História: Como desenvolvedor, quero iniciar a aplicação e suas dependências com Docker Compose para validar os fluxos sem provisionar AWS.
- Critérios de aceite:
  1. PostgreSQL e capturador de e-mails iniciam localmente com portas limitadas ao próprio computador e sem credenciais versionadas.
  2. Quando os módulos existirem, API Java 17 e frontend Angular iniciam pelo Compose, com banco, e-mail e URLs corretos.
  3. Uma verificação reproduzível demonstra o fluxo de acesso por link na aplicação local; a interface do capturador mostra a mensagem sem entrega externa.
  4. Os comandos de inicialização, parada, limpeza de dados e limitações estão documentados; nenhuma etapa exige conta AWS.

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
