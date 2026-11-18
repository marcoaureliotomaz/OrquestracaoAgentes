# Execução local com Docker

O primeiro ambiente da POC é local. `compose.yaml` inicia PostgreSQL e Mailpit, que captura os e-mails de login sem enviá-los para fora. **A API e o frontend ainda não existem no repositório**; as tarefas T-019 e T-020 adicionarão suas imagens ao Compose. Nenhuma conta AWS é necessária.

## Pré-requisitos

- Docker Desktop iniciado e Docker Compose v2 disponível.
- Portas locais 15432, 8025 e 1025 livres.

## Iniciar no PowerShell

Defina uma senha exclusiva de desenvolvimento na sessão do terminal, sem criar arquivo com o valor no projeto:

```powershell
$senhaLocal = Read-Host 'Senha local do PostgreSQL' -AsSecureString
$env:HABIT_DB_PASSWORD = [System.Net.NetworkCredential]::new('', $senhaLocal).Password
Remove-Variable senhaLocal
docker compose config --quiet
docker compose up -d
docker compose ps
```

O banco fica em `127.0.0.1:15432`, com base e usuário `habit_tracker`. O Mailpit mostra as mensagens em `http://127.0.0.1:8025`; aplicações executadas no host enviam SMTP para `127.0.0.1:1025`. Quando a API rodar dentro do Compose, usará `postgres:5432` e `mailpit:1025` na rede interna. As credenciais de banco serão fornecidas à API em tempo de execução, sem arquivo versionado.

## Parar e limpar

```powershell
docker compose down
```

O volume do banco permanece após a parada. Para apagar **os dados locais de teste** quando não forem mais necessários:

```powershell
docker compose down --volumes
Remove-Item Env:HABIT_DB_PASSWORD
```

Mailpit não usa volume persistente nesta configuração. Os links de teste somem quando o contêiner é removido. Não use contas ou dados reais neste ambiente. O fluxo completo de login local só poderá ser verificado depois que API e frontend forem implementados.
