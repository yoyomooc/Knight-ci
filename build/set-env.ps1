# 仓库地址
$RepoUrl = $env:GIT_REPO
$Depth = $env:GIT_DEPTH
if ([System.String]::IsNullOrWhiteSpace($Depth)) {
    $Depth = 10
}

Write-Host "RepoUrl: ${RepoUrl}"
Write-Host "Depth: ${Depth}"

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


Set-Location repo-code/build

# 执行错误判断
if ($Error.Count -eq 0) {
    exit 0
}
else {
    exit 1
}