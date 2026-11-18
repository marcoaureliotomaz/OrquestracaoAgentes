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

$branchMatch = [regex]::Match($BranchName, '^feature/(?<feature>F-\d{2})-[a-z0-9]+(?:-[a-z0-9]+)*$')
if (-not $branchMatch.Success) {
    throw 'Use uma branch feature/F-xx-descricao para commits de tarefas.'
}
$branchFeature = $branchMatch.Groups['feature'].Value

$subject = (Get-Content -LiteralPath $MessageFile -Encoding UTF8 -TotalCount 1).Trim()
$subjectMatch = [regex]::Match($subject, '^(feat|fix|test|docs|refactor|chore)\((?<feature>F-\d{2}) (?<task>T-\d{3})\): .+')
if (-not $subjectMatch.Success) {
    throw 'Use tipo(F-xx T-xxx): descrição objetiva no assunto do commit.'
}
$commitFeature = $subjectMatch.Groups['feature'].Value
$taskId = $subjectMatch.Groups['task'].Value

if ($commitFeature -cne $branchFeature) {
    throw 'A feature do commit deve corresponder à feature da branch.'
}

$taskFiles = @(Get-ChildItem -LiteralPath (Join-Path $projectRoot 'features') -Recurse -File -Filter ($taskId + '.md'))
$expectedPath = Join-Path (Join-Path (Join-Path $projectRoot 'features') $commitFeature) (Join-Path 'tarefas' ($taskId + '.md'))
if ($taskFiles.Count -ne 1 -or $taskFiles[0].FullName -cne $expectedPath) {
    throw 'A tarefa deve ter um único arquivo na pasta da feature do commit.'
}

$taskText = Get-Content -LiteralPath $expectedPath -Raw -Encoding UTF8
if ($taskText -cnotmatch ('(?m)^# ' + [regex]::Escape($taskId) + ' \S') -or
    $taskText -cnotmatch ('(?m)^- Feature: ' + [regex]::Escape($commitFeature) + '\r?$')) {
    throw 'O ID e a feature dentro do arquivo da tarefa devem corresponder ao commit.'
}
$story = [regex]::Match($taskText, '(?m)^- Hist[^:]+: (H-\d{2})\r?$')
$featureDirectory = Split-Path -Parent (Split-Path -Parent $expectedPath)
if (-not $story.Success -or -not (Test-Path -LiteralPath (Join-Path (Join-Path $featureDirectory 'historias') ($story.Groups[1].Value + '.md')))) {
    throw 'A história indicada na tarefa deve existir na mesma feature.'
}

& (Join-Path $PSScriptRoot 'validate-backlog.ps1') -Root $projectRoot

$global:LASTEXITCODE = 0
& (Join-Path $PSScriptRoot 'scan-secrets.ps1') -Root $projectRoot
if ($LASTEXITCODE -ne 0) {
    throw 'A verificação de segredos impediu o commit.'
}

Write-Output ("Commit validado: {0} {1}." -f $commitFeature, $taskId)
