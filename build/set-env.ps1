# 顶级目录
$rootPath = Split-Path -Parent (Get-Location).Path

# 读取当前项目配置
$ciConfigPath = Join-Path $rootPath "src" "ci-config.json"
$ciConfig = (Get-Content -Path $ciConfigPath -Encoding UTF8) | ConvertFrom-Json

# 设置环境变量
[Environment]::SetEnvironmentVariable("TAG", $ciConfig.branch, "Machine")
[Environment]::SetEnvironmentVariable("TAG", $ciConfig.branch)
Write-Host "标签的值🏷: ${env:TAG}"

[Environment]::SetEnvironmentVariable("Mode", $ciConfig.mode)


Write-Host "Mode: ${env:Mode}"

## 设置路径
Set-Location ./repo-code/build

