# Proteção de segredos e dados sensíveis

Nenhuma credencial real deve ser gravada neste repositório, incluindo código, arquivos de configuração, documentação, testes, logs, imagens, exemplos ou saídas geradas. `.gitignore` reduz commits acidentais, mas não protege arquivos já rastreados nem substitui a verificação do conteúdo.

## Fontes permitidas

- **Local:** variáveis de ambiente fornecidas fora do projeto. Arquivos locais com valores reais devem ficar fora da árvore do repositório. Exemplos versionados podem conter apenas nomes de variáveis e valores fictícios claramente identificados.
- **AWS:** preferir credenciais temporárias por papel IAM. Segredos de produção ficam em serviço apropriado, como AWS Secrets Manager, e são lidos em tempo de execução. Não colocar valores em CDK, CloudFormation, variáveis versionadas, logs ou comandos exibidos.
- **Google OAuth e e-mail:** `client_secret`, credenciais do provedor de e-mail e chaves de assinatura vêm de fonte externa segura. O identificador público do cliente pode ser configurado, mas não confundi-lo com o segredo.
- **Angular:** o bundle é público. Não colocar nele chaves privadas, segredos OAuth, credenciais AWS ou tokens de serviço. Configuração de URL e identificadores públicos não são segredos.

## Regras de implementação

- Incluir apenas nomes de variáveis em documentação e templates. Nunca pedir ao usuário que cole credenciais nesta conversa ou em arquivos do projeto.
- Não registrar links de acesso, tokens, cabeçalhos de autorização, cookies de sessão, e-mails completos ou dados privados em logs de aplicação e teste.
- Armazenar no banco apenas o hash do token de link de acesso; usar prazo curto, uso único e comparação segura. Não guardar o link completo.
- Evitar segredos em argumentos de linha de comando, mensagens de erro, relatórios de teste, screenshots e artefatos de build.
- Antes de concluir cada alteração, executar `scripts/scan-secrets.ps1` e inspecionar os arquivos modificados. A integração contínua deve executar o mesmo bloqueio quando for criada.
- Ao encontrar um segredo real, interromper o uso, remover a exposição, revogar ou trocar a credencial e verificar se ela entrou em histórico de versionamento ou artefatos. Não reproduzir o valor em relatórios.

## Limite do controle

O scanner local detecta formatos conhecidos e atribuições suspeitas; não prova ausência absoluta de segredos. Revisão humana e controle de acesso às fontes de segredo continuam necessários. O repositório Git já existe, mas ainda não há pipeline de CI.
