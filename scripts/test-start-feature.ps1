$ErrorActionPreference = 'Stop'
$scriptPath = Join-Path $PSScriptRoot 'start-feature.ps1'
$testRoot = Join-Path ([IO.Path]::GetTempPath()) ('start-feature-test-' + [guid]::NewGuid().ToString('N'))
$remote = Join-Path $testRoot 'remote.git'
$seed = Join-Path $testRoot 'seed'
$clone = Join-Path $testRoot 'clone'
$passed = 0

function Invoke-TestGit([string[]]$Arguments) {
    $ErrorActionPreference = 'Continue'
    $result = & git @Arguments 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw ('git {0} falhou: {1}' -f ($Arguments -join ' '), ($result -join ' '))
    }
    return $result
}

function Assert-Equal([string]$Actual, [string]$Expected, [string]$Message) {
    if ($Actual -cne $Expected) {
        throw ('{0}: esperado {1}; obtido {2}' -f $Message, $Expected, $Actual)
    }
    $script:passed++
}

function Assert-Rejected([string]$FeatureId, [string]$Slug, [string]$Message) {
    try {
        & $scriptPath -FeatureId $FeatureId -Slug $Slug -Root $clone | Out-Null
    } catch {
        $script:passed++
        return
    }
    throw ('A operacao deveria ter sido recusada: {0}' -f $Message)
}

try {
    New-Item -ItemType Directory -Path $testRoot, $seed | Out-Null
    Invoke-TestGit -Arguments @('init', '--bare', $remote) | Out-Null
    Invoke-TestGit -Arguments @('init', '-b', 'main', $seed) | Out-Null
    Set-Content -LiteralPath (Join-Path $seed 'BACKLOG.md') -Encoding UTF8 -Value @(
        '| [F-01](features/F-01/FEATURE.md) | Acesso | P0 |',
        '| F-02 | Habitos | Produto | P0 |'
    )
    Invoke-TestGit -Arguments @('-C', $seed, 'add', 'BACKLOG.md') | Out-Null
    Invoke-TestGit -Arguments @('-C', $seed, '-c', 'user.name=Test', '-c', 'user.email=test@example.invalid', 'commit', '-m', 'base') | Out-Null
    Invoke-TestGit -Arguments @('-C', $seed, 'remote', 'add', 'origin', $remote) | Out-Null
    Invoke-TestGit -Arguments @('-C', $seed, 'push', '-u', 'origin', 'main') | Out-Null
    Invoke-TestGit -Arguments @('-C', $remote, 'symbolic-ref', 'HEAD', 'refs/heads/main') | Out-Null
    Invoke-TestGit -Arguments @('clone', $remote, $clone) | Out-Null

    Set-Content -LiteralPath (Join-Path $seed 'change.txt') -Value 'remote update'
    Invoke-TestGit -Arguments @('-C', $seed, 'add', 'change.txt') | Out-Null
    Invoke-TestGit -Arguments @('-C', $seed, '-c', 'user.name=Test', '-c', 'user.email=test@example.invalid', 'commit', '-m', 'remote update') | Out-Null
    Invoke-TestGit -Arguments @('-C', $seed, 'push', 'origin', 'main') | Out-Null

    & $scriptPath -FeatureId F-01 -Slug acesso-conta -Root $clone | Out-Null
    Assert-Equal ((Invoke-TestGit -Arguments @('-C', $clone, 'branch', '--show-current')).Trim()) 'feature/F-01-acesso-conta' 'Branch criada'
    Assert-Equal ((Invoke-TestGit -Arguments @('-C', $clone, 'rev-parse', 'main')).Trim()) ((Invoke-TestGit -Arguments @('-C', $clone, 'rev-parse', 'origin/main')).Trim()) 'Main atualizada'
    Assert-Equal ((Invoke-TestGit -Arguments @('-C', $clone, 'rev-parse', 'HEAD')).Trim()) ((Invoke-TestGit -Arguments @('-C', $clone, 'rev-parse', 'main')).Trim()) 'Branch parte da main'

    Set-Content -LiteralPath (Join-Path $clone 'pending.txt') -Value 'local change'
    Assert-Rejected F-02 'habitos' 'arvore suja'
    Assert-Equal ((Invoke-TestGit -Arguments @('-C', $clone, 'branch', '--show-current')).Trim()) 'feature/F-01-acesso-conta' 'Branch preservada apos erro'
    Remove-Item -LiteralPath (Join-Path $clone 'pending.txt')

    Assert-Rejected F-01 'acesso-conta' 'branch existente'
    Assert-Rejected F-03 'inexistente' 'feature ausente do backlog'

    Invoke-TestGit -Arguments @('-C', $clone, 'switch', 'main') | Out-Null
    Set-Content -LiteralPath (Join-Path $clone 'local.txt') -Value 'local main'
    Invoke-TestGit -Arguments @('-C', $clone, 'add', 'local.txt') | Out-Null
    Invoke-TestGit -Arguments @('-C', $clone, '-c', 'user.name=Test', '-c', 'user.email=test@example.invalid', 'commit', '-m', 'local main') | Out-Null
    Assert-Rejected F-02 'habitos' 'main divergente'
    Assert-Equal ((Invoke-TestGit -Arguments @('-C', $clone, 'branch', '--show-current')).Trim()) 'main' 'Main preservada apos divergencia'

    Write-Output ('Testes de start-feature: {0} verificacoes aprovadas.' -f $passed)
} finally {
    $tempPath = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\', '/')
    $resolvedTestRoot = [IO.Path]::GetFullPath($testRoot).TrimEnd('\', '/')
    if ($resolvedTestRoot.StartsWith($tempPath + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase) -and
        $resolvedTestRoot -ne $tempPath -and (Test-Path -LiteralPath $resolvedTestRoot)) {
        Remove-Item -LiteralPath $resolvedTestRoot -Recurse -Force
    }
}
