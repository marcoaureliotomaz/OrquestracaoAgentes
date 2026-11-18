# Contrato de acesso por link e sessão — T-001 / H-01

Este contrato orienta as tarefas T-003 a T-016. A primeira versão usa API e interface na mesma origem, com Java 17, Spring Web MVC, Spring Security e PostgreSQL. A conta é criada após o consumo válido do primeiro link, não durante a solicitação. Não há senha local. O login Google de H-02 reutilizará a mesma sessão; a política de vínculo entre identidades será definida antes de implementá-lo.

## Solicitar o link

`POST /api/auth/email-link-requests` recebe JSON `{"email":"pessoa@example.invalid"}` e o cabeçalho de proteção CSRF. O endereço deve ter formato válido, ser limitado em tamanho e ser normalizado de forma consistente antes de qualquer busca: remover espaços nas extremidades e converter para minúsculas com `Locale.ROOT`, sem remover pontos nem sufixos `+`.

Para todo endereço válido, cadastrado ou novo, a API responde `202 Accepted` com `{"message":"Se o endereço puder receber mensagens, enviaremos um link de acesso."}`. A mesma resposta também vale para supressão por limite daquele endereço e para falha de envio; falhas internas são registradas sem endereço completo ou link. Não retornar se a conta existe, nem inserir identificador de conta na resposta. Entrada malformada recebe `400` com `INVALID_REQUEST`, sem consulta à conta.

O servidor gera token aleatório criptograficamente seguro de 32 bytes, codificado em Base64 URL sem preenchimento. Armazena somente SHA-256 do token, instante de expiração (15 minutos), identificador da solicitação e instante de consumo opcional. O token puro existe apenas durante a composição e o envio da mensagem. O link aponta para a rota da interface `/auth/consume#token=<token>`; o fragmento não é enviado ao servidor no GET. A interface remove o fragmento do histórico antes de chamar a API, mostra uma confirmação explícita e só consome o link após a ação da pessoa usuária. A página de retorno não carrega recursos de terceiros e usa política `Referrer-Policy: no-referrer`. Visualizações automáticas do link por clientes de e-mail não consomem o token.

Aplicar limites por origem e por endereço normalizado, sem armazenar o endereço puro no mecanismo de limitação. O limite por endereço não altera a resposta pública. Um limite por origem pode responder `429 TOO_MANY_REQUESTS` com `Retry-After`, pois independe da existência da conta. Definir os limiares e testar abuso em T-009 antes de expor o fluxo. Não confiar em `X-Forwarded-For` de clientes; aceitar cabeçalhos de proxy somente de infraestrutura configurada como confiável.

## Consumir o link

`POST /api/auth/email-link-sessions` recebe JSON `{"token":"<valor recebido no fragmento>"}` e o cabeçalho CSRF. O token nunca vai na URL da API. Token ausente, desconhecido, expirado ou já consumido retorna o mesmo `400` com `INVALID_OR_EXPIRED_LINK` e mensagem para pedir um novo link. Não distinguir esses estados na resposta pública nem criar sessão. Respostas de autenticação usam `Cache-Control: no-store` e nunca incluem o token.

O servidor calcula o hash e consome o registro em transação, com atualização condicional a `consumed_at IS NULL` e `expires_at > now` no banco. Exatamente uma requisição concorrente pode marcar o token como consumido. Na mesma transação, encontra ou cria a conta do endereço verificado pelo link. A unicidade do endereço normalizado no banco protege contra criação concorrente de contas duplicadas. Falha antes do commit desfaz o consumo; falha ao abrir a sessão após o commit não permite reuso do link e deve oferecer solicitação de outro.

O sucesso responde `204 No Content`, com cookie de sessão e sem token no corpo. A interface mostra sucesso somente após a resposta. O backend nunca aceita o e-mail enviado pelo navegador como identidade no consumo: usa apenas o endereço associado ao hash persistido.

## Sessão comum aos métodos de login

Sessão opaca, gerida pelo servidor, identificada por cookie `HABIT_SESSION` com `HttpOnly`, `SameSite=Lax`, `Path=/` e sem atributo `Domain`. Usar `Secure` em HTTPS; a única exceção é o ambiente local servido por HTTP em loopback. Renovar o identificador ao autenticar para evitar fixação de sessão. Encerrar após 12 horas sem atividade e, no máximo, 7 dias desde a autenticação; o servidor valida os dois prazos. A sessão contém apenas o identificador interno da conta e metadados mínimos, nunca token de link ou credenciais Google. O navegador não guarda token de sessão em `localStorage` ou `sessionStorage`.

`GET /api/auth/session` responde `200` com dados mínimos da conta autenticada ou `401` com `AUTHENTICATION_REQUIRED`. `POST /api/auth/logout` invalida a sessão no servidor, expira o cookie e responde `204`. Para requisições que mudam estado, usar proteção CSRF do Spring Security: a interface obtém o token em `GET /api/auth/csrf` e o envia em `X-CSRF-TOKEN`. Depois de autenticar ou encerrar a sessão, obtém um token CSRF novo. A API restringe CORS à própria origem; a publicação deve usar TLS. Uma sessão inválida nunca autoriza acesso a dados da conta.

## Erros e verificação

Respostas de erro usam `{"code":"CODIGO","message":"Mensagem recuperável."}` sem e-mail, token ou detalhe interno. O servidor não registra URL completa, fragmento, corpo do consumo, cabeçalho de cookie, token CSRF ou endereço completo. O frontend não envia o token de link a ferramentas de analytics, relatórios de erro ou imagens.

| Cenário | Resultado esperado | Tarefa de verificação |
| --- | --- | --- |
| Solicitação para endereço existente ou novo | Mesmo `202` e corpo; link recebido quando envio permitido | T-008 e T-013 |
| Entrada inválida | `400 INVALID_REQUEST`, sem consulta de conta | T-008 |
| Token expirado, desconhecido ou repetido | Mesmo `400 INVALID_OR_EXPIRED_LINK`, sem sessão | T-006 e T-010 |
| Duas tentativas simultâneas com o mesmo token | Exatamente uma sessão criada | T-006 e T-013 |
| Excesso de solicitações | Limitação sem enumeração de contas | T-009 e T-014 |
| Sessão válida, expirada e encerrada | `200` só para a válida; demais `401` | T-010 e T-013 |
| Requisição sem CSRF ou de origem não permitida | Ação recusada | T-010 e T-014 |

As histórias H-02 e H-03 reutilizam a sessão, mas o login Google, o vínculo de identidades e a verificação de novo e-mail não são implementados nesta tarefa. Revisar a política de vínculo antes de H-02 e exigir verificação do novo endereço em H-03.
