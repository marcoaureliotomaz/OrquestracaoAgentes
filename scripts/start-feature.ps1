param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^F-\d{2}$')]
    [string]$FeatureId,

    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[a-z0-9]+(?:-[a-z0-9]+)*$')]
    [string]$Slug,

    [string]$Root = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
$rootPath = (Resolve-Path -LiteralPath $Root).Path
$branchName = 'feature/{0}-{1}' -f $FeatureId, $Slug

function Invoke-Git([string[]]$Arguments) {
    $ErrorActionPreference = 'Continue'
    $result = & git -C $rootPath @Arguments 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw ('git {0} falhou: {1}' -f ($Arguments -join ' '), ($result -join ' '))
    }
    return $result
}

$repositoryRoot = (Invoke-Git -Arguments @('rev-parse', '--show-toplevel') | Select-Object -First 1).Trim()
if ([IO.Path]::GetFullPath($repositoryRoot).TrimEnd('\', '/') -ine $rootPath.TrimEnd('\', '/')) {
    throw 'Informe a raiz do repositorio em -Root.'
}

$changes = @(Invoke-Git -Arguments @('status', '--porcelain=v1', '--untracked-files=all'))
if ($changes.Count -gt 0) {
    throw 'A arvore de trabalho deve estar limpa antes de iniciar uma feature.'
}

$backlogPath = Join-Path $rootPath 'BACKLOG.md'
if (-not (Test-Path -LiteralPath $backlogPath -PathType Leaf)) {
    throw 'BACKLOG.md nao foi encontrado.'
}
$featurePattern = '^\| (?:' + [regex]::Escape($FeatureId) + '|\[' + [regex]::Escape($FeatureId) + '\]\(features/' + [regex]::Escape($FeatureId) + '/FEATURE\.md\)) \|'
if (-not (Select-String -LiteralPath $backlogPath -Pattern $featurePattern -Quiet)) {
    throw ('A feature {0} nao consta em BACKLOG.md.' -f $FeatureId)
}

Invoke-Git -Arguments @('remote', 'get-url', 'origin') | Out-Null
Invoke-Git -Arguments @('rev-parse', '--verify', 'refs/heads/main') | Out-Null
Invoke-Git -Arguments @('fetch', 'origin') | Out-Null
Invoke-Git -Arguments @('rev-parse', '--verify', 'refs/remotes/origin/main') | Out-Null

& git -C $rootPath show-ref --verify --quiet ('refs/heads/' + $branchName)
if ($LASTEXITCODE -eq 0) {
    throw ('A branch local {0} ja existe.' -f $branchName)
}
& git -C $rootPath show-ref --verify --quiet ('refs/remotes/origin/' + $branchName)
if ($LASTEXITCODE -eq 0) {
    throw ('A branch remota origin/{0} ja existe.' -f $branchName)
}

& git -C $rootPath merge-base --is-ancestor main origin/main
if ($LASTEXITCODE -ne 0) {
    throw 'main local divergiu de origin/main; resolva a divergencia antes de criar a branch.'
}

Invoke-Git -Arguments @('switch', 'main') | Out-Null
Invoke-Git -Arguments @('merge', '--ff-only', 'origin/main') | Out-Null
$mainCommit = (Invoke-Git -Arguments @('rev-parse', 'main') | Select-Object -First 1).Trim()
$remoteCommit = (Invoke-Git -Arguments @('rev-parse', 'origin/main') | Select-Object -First 1).Trim()
if ($mainCommit -cne $remoteCommit) {
    throw 'main e origin/main nao apontam para o mesmo commit.'
}

Invoke-Git -Arguments @('switch', '-c', $branchName, 'main') | Out-Null
Write-Output ('Branch criada: {0} (base {1}).' -f $branchName, $mainCommit.Substring(0, 7))
