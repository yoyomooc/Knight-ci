# set-mode.ps1

$rootPath = Split-Path -Parent (Get-Location).Path
$ciConfigPath = Join-Path $rootPath "src" "ci-config.json"
$ciConfig = (Get-Content -Path $ciConfigPath -Encoding UTF8) | ConvertFrom-Json
[Environment]::SetEnvironmentVariable("Mode", $ciConfig.mode)
echo "mode=$($ciConfig.mode)" >> $env:GITHUB_OUTPUT
