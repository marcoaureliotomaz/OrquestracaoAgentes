param(
    [Parameter(Mandatory = $true)]
    [string]$MessageFile,
    [string]$BranchName
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot

if (-not $BranchName) {
    $BranchName = (& git -C $projectRoot branch --show-current).Trim()
    if ($LASTEXITCODE -ne 0) {
        throw 'Não foi possível identificar a branch atual.'
    }
}

if ($BranchName -cnotmatch '^feature/(?<feature>F-\d{2})-[a-z0-9]+(?:-[a-z0-9]+)*$') {
    throw 'Use uma branch feature/F-xx-descricao para commits de tarefas.'
}
$branchFeature = $Matches.feature

$subject = (Get-Content -LiteralPath $MessageFile -Encoding UTF8 -TotalCount 1).Trim()
if ($subject -cnotmatch '^(feat|fix|test|docs|refactor|chore)\((?<feature>F-\d{2}) (?<task>T-\d{3})\): .+') {
    throw 'Use tipo(F-xx T-xxx): descrição objetiva no assunto do commit.'
}
$commitFeature = $Matches.feature
$taskId = $Matches.task

if ($commitFeature -cne $branchFeature) {
    throw 'A feature do commit deve corresponder à feature da branch.'
}

$taskRows = @(Get-Content -LiteralPath (Join-Path $projectRoot 'TAREFAS.md') -Encoding UTF8 |
    Where-Object { $_ -match ('^\| ' + [regex]::Escape($taskId) + ' \| (?<feature>F-\d{2}) \|') })
if ($taskRows.Count -ne 1 -or $taskRows[0] -cnotmatch ('^\| ' + [regex]::Escape($taskId) + ' \| ' + [regex]::Escape($commitFeature) + ' \|')) {
    throw 'A tarefa deve aparecer uma vez em TAREFAS.md, vinculada à feature do commit.'
}

$global:LASTEXITCODE = 0
& (Join-Path $PSScriptRoot 'scan-secrets.ps1') -Root $projectRoot
if ($LASTEXITCODE -ne 0) {
    throw 'A verificação de segredos impediu o commit.'
}

Write-Output ("Commit validado: {0} {1}." -f $commitFeature, $taskId)
