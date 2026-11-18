# Estratégia AWS de baixo custo para a POC

Esta estratégia preserva Java 17, Spring Boot, Angular e PostgreSQL. Seu objetivo é demonstrar a aplicação com custo pequeno e previsível, sem introduzir vários serviços gerenciados antes de existir carga real. Preços e elegibilidade ao Free Tier devem ser conferidos na conta e na Região escolhida antes de qualquer criação de recurso. **Nenhum recurso AWS foi criado.**

## Modos de uso

| Modo | Composição | Custo AWS esperado | Quando usar |
| --- | --- | --- | --- |
| Desenvolvimento diário | Java, Angular e PostgreSQL executados localmente; e-mail capturado em teste | Nenhum recurso AWS permanente | Implementação, testes e code review. |
| Demonstração pública curta | Uma instância Linux Amazon Lightsail de **2 GB**, com API Spring Boot, PostgreSQL e arquivos estáticos Angular no mesmo servidor; proxy HTTPS | Plano anunciado de **US$ 12/mês** se mantido o mês inteiro, mais e-mail, domínio, snapshots e eventuais excedentes | Apenas quando for necessário acessar a POC fora da máquina local. |

O plano Lightsail de 2 GB inclui 2 vCPUs e 60 GB SSD na tabela pública consultada. Ele é um **tamanho inicial para teste**, não uma promessa de capacidade. Se medições mostrarem pressão de memória ou latência ruim, ajustar a aplicação ou avaliar o plano de 4 GB antes de aceitar mais custo. [Preços do Lightsail](https://aws.amazon.com/lightsail/pricing/).

## Desenho da demonstração

```text
Navegador móvel/desktop
        │ HTTPS
        ▼
Lightsail Linux 2 GB
  ├── proxy web: Angular estático e encaminhamento da API
  ├── Spring Boot Java 17
  └── PostgreSQL: acesso apenas local
```

- Um único domínio/origem simplifica HTTPS, cookies de sessão e chamadas frontend–backend. O domínio, se ainda não existir, é um custo separado.
- Expor somente 80/443 ao público para web e limitar SSH ao endereço administrativo necessário. Não expor PostgreSQL à internet. [Firewall Lightsail](https://docs.aws.amazon.com/lightsail/latest/userguide/understanding-firewall-and-port-mappings-in-amazon-lightsail.html).
- Usar TLS e armazenar credenciais fora do repositório. Não colocar segredos em código, CDK, `UserData`, imagens, logs ou arquivos estáticos. Configuração local da instância deve ter permissões restritas e seguir `SEGREDOS.md`.
- Evitar chamadas à API da AWS a partir da aplicação nessa instância. Se o envio real de e-mail usar credencial SMTP, mantê-la fora do projeto em configuração de execução com acesso restrito; não colocar uma chave de acesso AWS permanente no servidor. Reavaliar o modelo de hospedagem antes de introduzir acesso programático a outros serviços AWS.
- Para a POC, usar um adaptador de e-mail que permita testes sem envio real; se o login público exigir envio, avaliar Amazon SES e sua configuração antes de ativá-lo. SES tem cobrança por volume. [Preços do SES](https://aws.amazon.com/ses/pricing/).
- Manter os dados em um único PostgreSQL local à instância reduz custo e latência, mas cria um ponto único de falha. Usar contas e dados descartáveis no teste; se houver dados que precisem persistir, planejar backup e restauração antes da demonstração, com o custo de snapshots ou exportação incluído. [Preço de snapshots](https://aws.amazon.com/lightsail/pricing/).
- O AWS CDK v2 pode descrever a instância por `CfnInstance`. Usar `cdk synth` e `cdk diff` antes de provisionar. A automação não deve conter segredos. [Recurso CDK Lightsail](https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.aws_lightsail.CfnInstance.html).

## Controles de custo

1. Estimar custo na Região escolhida antes de provisionar, incluindo instância, domínio, e-mail, backups e tráfego excedente. Não presumir créditos ou Free Tier.
2. Criar orçamento e alertas; se a conta oferecer limite de gasto por projeto, avaliá-lo. Um alerta comum pode chegar depois do gasto e não é teto rígido. [AWS Budgets](https://docs.aws.amazon.com/cost-management/latest/userguide/bcm-lite-use-budget.html).
3. Não criar nesta POC RDS, balanceador de carga, NAT Gateway, cluster ECS ou CDN sem requisito e comparação de custo. Cada serviço adicional precisa de justificativa e estimativa.
4. Marcar recursos como POC e documentar data de revisão e procedimento de exclusão. **Parar uma instância Lightsail não encerra a cobrança; é preciso excluí-la** quando a demonstração terminar. [Cobrança Lightsail](https://docs.aws.amazon.com/lightsail/latest/userguide/amazon-lightsail-frequently-asked-questions-faq-billing-and-account-management.html).
5. Revisar custos reais após a primeira demonstração e reduzir ou eliminar recursos ociosos.

## Controles de performance

- Servir Angular como arquivos estáticos compactados e com cache para arquivos versionados; deixar API e PostgreSQL na mesma instância para evitar latência de rede entre eles.
- Medir memória, CPU, latência do registro e do dashboard com uma carga de teste representativa, incluindo múltiplos hábitos e um ano de histórico. Não aceitar o tamanho de 2 GB apenas por estimativa.
- Manter consultas do calendário limitadas ao período visível e agregar indicadores mensais sem uma consulta por hábito. Evitar cache e outros componentes pagos antes de medir gargalos.
- Registrar os resultados e o limite de usuários observado; ampliar a instância somente se uma meta acordada não for cumprida.

## Limites

A instância única não fornece alta disponibilidade e exige atualização, backup e operação do sistema operacional. É adequada apenas para a fase de desenvolvimento e demonstração de baixa carga. Para produção ou aumento de usuários, refazer a avaliação de segurança, desempenho, disponibilidade e custo.
