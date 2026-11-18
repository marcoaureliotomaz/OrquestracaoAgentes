# Escopo do sistema — tracker de hábitos

Este documento define o produto. O agente de produto detalha as features e histórias em `BACKLOG.md`; o agente de arquitetura decide como implementá-las.

## 1. Objetivo

Criar uma plataforma pessoal para planejar hábitos e registrar o que foi realizado a cada dia. O usuário acompanha constância e volume em um calendário de quadrados com intensidade de cor, semelhante ao gráfico de contribuições do GitHub. A primeira entrega será uma aplicação web responsiva, prática no celular. Um aplicativo mobile fica para uma etapa futura.

## 2. Usuários e necessidades

- Cada pessoa usa uma conta própria e pode manter vários hábitos independentes.
- O usuário quer registrar rapidamente uma execução e sua quantidade, sem preencher um formulário longo a cada vez.
- O usuário quer consultar histórico diário, frequência e intensidade de cada hábito.
- O usuário quer personalizar a aparência do sistema e compartilhar uma imagem do próprio progresso por redes sociais ou WhatsApp.

## 3. Funcionalidades da primeira versão web

### Conta e acesso

- Criar e acessar uma conta por **link de acesso enviado por e-mail** ou por **Google**. Não haverá senha local; um novo link substitui a necessidade de recuperação de senha.
- Consultar e editar dados básicos da conta. Campos mínimos propostos: nome de exibição e e-mail. Alteração do endereço de e-mail deve exigir verificação do novo endereço.
- Quando os dois métodos usarem o mesmo e-mail verificado, o vínculo entre métodos deve ser tratado com verificação segura para evitar contas duplicadas ou tomada de conta.

### Hábitos e metas

- Cadastrar, consultar e editar vários hábitos por usuário.
- Cada hábito possui nome, cor e ícone opcional.
- Associar uma categoria: **físico**, **intelecto**, **espiritual** ou **outros**.
- Oferecer sugestões como ler, estudar, musculação e correr, sem impedir um hábito personalizado.
- Definir a unidade de registro: **tempo**, **distância em km** ou **execução simples**.
- Oferecer três formatos de planejamento: **dias da semana com quantidade alvo por dia**, **quantidade alvo todos os dias** e **registro livre sem meta**. A quantidade alvo usa a unidade do hábito. Um usuário pode registrar atividade mesmo em dia sem meta.

### Registro diário e acompanhamento

- Registrar a realização de cada hábito individualmente, com poucos toques ou cliques.
- Permitir mais de um registro do mesmo hábito no mesmo dia; preservar cada lançamento e apresentar o total diário. Para tempo, informar horas e minutos; para distância, km; para execução simples, cada marcação conta uma realização.
- Permitir criar lançamentos em dias anteriores, corrigir uma quantidade ou data e excluir lançamentos feitos por engano. Totais e calendário devem refletir cada alteração.
- Exibir um calendário de quadrados por hábito. **A intensidade do quadrado depende do número de registros feitos naquele dia**, não da soma de horas ou km. Exibir o total na unidade do hábito separadamente para não ocultar o volume realizado.
- Distinguir dias sem registro de dias com registro e permitir consultar o detalhe diário. O estado não deve depender apenas de cor.
- No dashboard principal, mostrar em cada hábito um indicador textual **Abaixo**, **Igual** ou **Superando** em relação ao mês anterior, usando o total na unidade do hábito: horas e minutos, km ou número de execuções. Mostrar também os dois totais e os períodos comparados. Para um hábito criado somente no mês atual, mostrar **Sem histórico anterior** em vez de uma comparação enganosa.

### Interface e compartilhamento

- Funcionar em navegadores modernos com layout responsivo, priorizando uso em dispositivos móveis.
- Oferecer cinco temas selecionáveis: **claro**, **escuro**, **militar**, **feminino** e **neutro**. As cores específicas dos três últimos serão definidas por UI/UX. A cor do hábito continua identificável em cada tema.
- Permitir gerar uma imagem simples de **um hábito selecionado** ou de **um resumo de todos os hábitos** para compartilhamento por WhatsApp ou redes sociais, mediante ação explícita do usuário. Não publicar automaticamente. Se o navegador não oferecer compartilhamento direto, permitir salvar a imagem.

## 4. Fora do escopo da primeira versão

- Aplicativos nativos para Android e iOS; a arquitetura deve permitir futura interface mobile sem regras de negócio exclusivas do navegador.
- Senha local e fluxo de recuperação de senha, substituídos pelo link de acesso por e-mail.
- Rede social interna, ranking público, comentários ou compartilhamento automático.
- Integrações com relógios, sensores ou serviços de atividade física.
- Gamificação, lembretes e notificações, pois ainda não foram solicitados.

## 5. Regras de negócio e dados

- Hábitos e registros pertencem a um único usuário. O acesso a um registro deve ser autorizado pelo proprietário, inclusive por identificadores diretos de API.
- Um hábito define sua unidade de medida; cada registro guarda data, quantidade nessa unidade e vínculo com o hábito. O sistema soma os registros do dia sem perder cada lançamento individual.
- Tempo deve aceitar duração maior que zero e ser armazenado em unidade interna precisa, como minutos; a interface mostra horas e minutos. Distância também aceita valores positivos. Execução simples soma uma unidade por marcação.
- O calendário mostra intensidade crescente conforme a contagem diária de registros. Um lançamento de três horas e um de quinze minutos têm a mesma intensidade se cada dia contiver apenas um registro; o total de horas aparece no detalhe.
- O indicador mensal soma as quantidades de **1º até a data atual no fuso do dispositivo** e compara com **1º até o mesmo dia do mês anterior**. Se esse dia não existir no mês anterior, usar o último dia daquele mês e exibir as datas reais comparadas. A comparação usa totais exatos na unidade do hábito, não a quantidade de registros nem uma porcentagem. Valor atual menor, igual ou maior determina o texto do indicador.
- Se o hábito já existia no mês anterior mas não há lançamentos no período, o total anterior é zero. Se ele foi criado no mês atual, o indicador mostra **Sem histórico anterior**.
- Ao criar um lançamento, a data padrão segue o fuso horário atual do dispositivo. A data escolhida fica gravada com o registro e não muda retroativamente se o dispositivo trocar de fuso. O usuário pode escolher uma data anterior ao lançar ou corrigi-la depois.
- Alterar ou excluir um lançamento recalcula totais diários, cumprimento de meta, intensidade do quadrado e comparação mensal correspondentes.
- Cor, ícone, categoria e tema são preferências de apresentação; não podem alterar ou apagar o histórico.
- A imagem compartilhada deve conter apenas informações escolhidas pelo usuário e não incluir e-mail, identificadores internos ou outros dados privados por padrão.

## 6. Requisitos não funcionais

### Segurança — prioridade 1

- Isolar contas, hábitos e registros entre usuários; proteger o link de acesso, a sessão e a integração Google.
- Expirar links de acesso após uso ou prazo curto, limitar abuso dos pedidos de link e não revelar se um e-mail já possui conta.
- Proteger dados pessoais em logs e imagens compartilhadas. O servidor valida autorização e entradas, independentemente da interface.
- Nenhuma credencial, chave privada ou token real será gravado no código, em configurações versionadas, documentação, testes ou artefatos. Seguir `SEGREDOS.md`.

### Performance — prioridade 2

- Registro rápido de um hábito no celular e carregamento eficiente do calendário, inclusive com vários hábitos e anos de histórico.
- Buscar ou agregar apenas os dados necessários ao período exibido. Metas numéricas de latência e volume serão definidas após estimar o uso esperado.
- Carregar os indicadores mensais de todos os hábitos do dashboard sem consultar o histórico completo nem fazer uma consulta separada para cada hábito.

### Qualidade e experiência — prioridade 3

- Interface responsiva, acessível por teclado e legível nos cinco temas; usar WCAG 2.2 nível AA como referência.
- Mostrar confirmação de registro, erros recuperáveis e estados vazios claramente. Permitir verificar a quantidade informada antes de salvar.
- Testar agregação diária, isolamento entre usuários, autenticação e principais jornadas móveis.
- A entrega de código deve cumprir cobertura mínima de **95%** conforme as métricas de `QUALIDADE_TESTES.md`, além de testes integrados, execução automatizada e relatório verificável.

### Plataforma técnica

- O backend deve usar **Java 17**. Frameworks e ferramentas padrão ficam em `PADROES_TECNICOS.md`; o projeto deve compilar e executar com Java 17.
- A primeira forma de execução da aplicação será local, com Docker Compose para frontend Angular, API Java 17, PostgreSQL e capturador de e-mails. O ambiente deve permitir testar o fluxo de link de acesso sem envio real de mensagens. Planejamento e provisionamento AWS ficam para uma etapa posterior, após o fluxo local completo funcionar e ser medido.

## 7. Critérios de aceite da primeira versão

1. Uma pessoa consegue acessar a conta por link de e-mail ou Google, criar dois hábitos com categorias e unidades diferentes e visualizar ambos na própria área.
2. Ao registrar duas sessões de tempo do mesmo hábito no mesmo dia, o sistema preserva ambas e mostra a soma correta em horas e minutos.
3. Ao registrar distância ou execução simples, o sistema apresenta o total do dia na unidade correta.
4. O calendário mostra dias com e sem atividade; dias com mais registros têm intensidade maior, independentemente das quantidades lançadas.
5. O usuário consegue criar hábitos nos três formatos de meta e ver se os registros atendem à meta nos dias aplicáveis; registro livre não aparece como atraso.
6. Um usuário não consegue visualizar, alterar ou registrar dados de outro usuário por interface ou API.
7. O usuário consegue alternar entre os cinco temas sem perder seus hábitos e registros.
8. O usuário consegue gerar uma imagem do progresso para salvar ou compartilhar em navegador compatível, sem divulgação automática.
9. Os fluxos principais são utilizáveis em uma tela de celular.
10. O usuário consegue lançar, corrigir e excluir atividade de dias anteriores; os totais e quadrados são atualizados sem afetar outros hábitos.
11. A tela oferece os dois formatos de imagem: hábito individual e resumo de todos os hábitos.
12. Cada hábito no dashboard mostra Abaixo, Igual ou Superando conforme o total na sua unidade no mês atual até hoje versus o mesmo período do mês anterior; um hábito novo sem mês anterior mostra Sem histórico anterior.

## 8. Decisões em aberto

1. **Detalhes visuais:** paletas militar, feminino e neutro serão propostas pelo agente UI/UX e avaliadas antes da implementação.
2. **Carga esperada:** número aproximado de usuários e histórico médio por hábito ainda não foram estimados; isso será necessário para metas numéricas de performance e escolha de hospedagem.
