param(
    [string]$Root = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
$rootPath = (Resolve-Path -LiteralPath $Root).Path
$excludedDirectories = @('.git', 'node_modules', '.angular')
$textExtensions = @('.md', '.txt', '.json', '.yml', '.yaml', '.properties', '.java', '.ts', '.tsx', '.js', '.jsx', '.xml', '.ps1', '.sh', '.toml', '.sql', '.html', '.css')
$sensitiveFileName = '^(?:\.env(?:\..+)?|credentials(?:\..+)?|client_secret.*\.json|service-account.*\.json|application-(?:local|secret|secrets)\.(?:yml|yaml|properties)|.+\.(?:pem|key|p12|pfx|jks|keystore|tfstate)(?:\..+)?)$'
$patterns = [ordered]@{
    'bloco de chave privada' = '-----BEGIN (?:RSA |EC |OPENSSH |DSA )?PRIVATE KEY-----'
    'chave de acesso AWS' = '\b(?:AKIA|ASIA)[A-Z0-9]{16}\b'
    'chave de API Google' = '\bAIza[0-9A-Za-z_-]{35}\b'
    'token GitHub' = '\bgh[pousr]_[A-Za-z0-9_]{20,}\b'
    'token OpenAI' = '\bsk-[A-Za-z0-9_-]{20,}\b'
    'credencial em URL' = 'https?://[^\s/@:]+:[^\s/@]+@'
    'credencial atribuida em texto' = '(?i)\b(?:password|passwd|client[_-]?secret|clientSecret|api[_-]?key|apiKey|secret[_-]?key|secretKey|access[_-]?key|accessKey|aws[_-]?secret[_-]?access[_-]?key)\b["'']?\s*[=:]\s*["'']?[A-Za-z0-9+/=_-]{12,}'
}
$findings = New-Object System.Collections.Generic.List[string]
$scannedFiles = 0

function Scan-Directory([string]$directoryPath) {
    foreach ($item in Get-ChildItem -LiteralPath $directoryPath -Force) {
        if ($item.PSIsContainer) {
            if ($excludedDirectories -notcontains $item.Name) {
                Scan-Directory $item.FullName
            }
            continue
        }

        $relativePath = $item.FullName.Substring($rootPath.Length).TrimStart('\', '/')
        if ($item.Name -match $sensitiveFileName -and $item.Name -notmatch '^\.env\.(?:example|sample)$') {
            $findings.Add(('{0}: nome de arquivo sensivel' -f $relativePath))
        }
        if ($textExtensions -notcontains $item.Extension -and $item.Name -notlike '.env*') {
            continue
        }

        $script:scannedFiles++
        $lineNumber = 0
        foreach ($line in Get-Content -LiteralPath $item.FullName -Encoding UTF8) {
            $lineNumber++
            foreach ($kind in $patterns.Keys) {
                if ($line -match $patterns[$kind]) {
                    $findings.Add(('{0}:{1}: {2}' -f $relativePath, $lineNumber, $kind))
                }
            }
        }
    }
}

Scan-Directory $rootPath
if ($findings.Count -gt 0) {
    $findings | ForEach-Object { Write-Output $_ }
    Write-Output ('Possiveis segredos encontrados: {0}. Nenhum valor foi exibido.' -f $findings.Count)
    exit 1
}

Write-Output ('Verificacao concluida: {0} arquivos de texto, nenhum padrao sensivel encontrado.' -f $scannedFiles)
