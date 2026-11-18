param(
    [string]$Root = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path -LiteralPath $Root).Path
$featuresRoot = Join-Path $projectRoot 'features'
$backlog = Get-Content -LiteralPath (Join-Path $projectRoot 'BACKLOG.md') -Raw -Encoding UTF8
$taskIndex = Get-Content -LiteralPath (Join-Path $projectRoot 'TAREFAS.md') -Raw -Encoding UTF8
$featureIds = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
$storyIds = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
$taskIds = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)

foreach ($featureDirectory in Get-ChildItem -LiteralPath $featuresRoot -Directory) {
    $featureId = $featureDirectory.Name
    if ($featureId -cnotmatch '^F-\d{2}$' -or -not $featureIds.Add($featureId)) {
        throw "Pasta de feature invalida ou duplicada: $featureId"
    }

    $featurePath = Join-Path $featureDirectory.FullName 'FEATURE.md'
    if (-not (Test-Path -LiteralPath $featurePath)) { throw "Arquivo da feature ausente: $featureId" }
    $featureText = Get-Content -LiteralPath $featurePath -Raw -Encoding UTF8
    if ($featureText -cnotmatch ('(?m)^# ' + [regex]::Escape($featureId) + ' \S') -or
        -not $backlog.Contains("(features/$featureId/FEATURE.md)")) {
        throw "Feature sem identificacao ou indice: $featureId"
    }

    $progressPath = Join-Path $featureDirectory.FullName 'PROGRESSO.md'
    if (-not (Test-Path -LiteralPath $progressPath)) { throw "Historico de progresso ausente: $featureId" }
    $progressText = Get-Content -LiteralPath $progressPath -Raw -Encoding UTF8
    if ($progressText -cnotmatch ('(?m)^# Progresso da feature ' + [regex]::Escape($featureId) + '\r?$') -or
        -not $featureText.Contains('(PROGRESSO.md)')) {
        throw "Historico de progresso sem vinculo valido: $featureId"
    }
    $rounds = [regex]::Matches($progressText, '(?m)^### R-(\d{3})\b')
    for ($roundNumber = 1; $roundNumber -le $rounds.Count; $roundNumber++) {
        if ($rounds[$roundNumber - 1].Groups[1].Value -cne $roundNumber.ToString('D3')) {
            throw "Rodadas fora de ordem: $featureId"
        }
    }

    $storyDirectory = Join-Path $featureDirectory.FullName 'historias'
    if (-not (Test-Path -LiteralPath $storyDirectory)) { throw "Pasta de historias ausente: $featureId" }
    foreach ($storyFile in Get-ChildItem -LiteralPath $storyDirectory -File -Filter 'H-*.md') {
        $storyId = $storyFile.BaseName
        $storyText = Get-Content -LiteralPath $storyFile.FullName -Raw -Encoding UTF8
        if ($storyId -cnotmatch '^H-\d{2}$' -or -not $storyIds.Add($storyId) -or
            $storyText -cnotmatch ('(?m)^### ' + [regex]::Escape($storyId) + ' \S') -or
            $storyText -cnotmatch ('(?m)^- Feature: ' + [regex]::Escape($featureId) + ';') -or
            -not $backlog.Contains("(features/$featureId/historias/$storyId.md)") -or
            -not $featureText.Contains("(historias/$storyId.md)")) {
            throw "Historia sem vinculo valido: $storyId"
        }
    }

    $taskDirectory = Join-Path $featureDirectory.FullName 'tarefas'
    if (-not (Test-Path -LiteralPath $taskDirectory)) { continue }
    foreach ($taskFile in Get-ChildItem -LiteralPath $taskDirectory -File -Filter 'T-*.md') {
        $taskId = $taskFile.BaseName
        $taskText = Get-Content -LiteralPath $taskFile.FullName -Raw -Encoding UTF8
        $story = [regex]::Match($taskText, '(?m)^- Hist[^:]+: (H-\d{2})\r?$')
        if ($taskId -cnotmatch '^T-\d{3}$' -or -not $taskIds.Add($taskId) -or
            $taskText -cnotmatch ('(?m)^# ' + [regex]::Escape($taskId) + ' \S') -or
            $taskText -cnotmatch ('(?m)^- Feature: ' + [regex]::Escape($featureId) + '\r?$') -or
            $taskText -cnotmatch '(?m)^- Estado: \S' -or
            -not $story.Success -or -not (Test-Path -LiteralPath (Join-Path $storyDirectory ($story.Groups[1].Value + '.md'))) -or
            -not $taskIndex.Contains("(features/$featureId/tarefas/$taskId.md)") -or
            -not $featureText.Contains("(tarefas/$taskId.md)")) {
            throw "Tarefa sem vinculo valido: $taskId"
        }
    }
}

foreach ($link in [regex]::Matches(($backlog + $taskIndex), '\]\((features/[^)]+)\)')) {
    if (-not (Test-Path -LiteralPath (Join-Path $projectRoot $link.Groups[1].Value))) {
        throw "Link ausente nos indices: $($link.Groups[1].Value)"
    }
}

Write-Output ("Estrutura valida: {0} features, {1} historias, {2} tarefas." -f $featureIds.Count, $storyIds.Count, $taskIds.Count)
