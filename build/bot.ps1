
param(
    [string]$BotUrl,
    [string]$Msg
)

# 设置时区
$currentDate = (Get-Date).ToUniversalTime().AddHours(8)
$currentDateStr = $currentDate.ToString('yyyy-MM-dd HH:mm:ss')

$rootPath = Split-Path -Parent (Get-Location).Path

# 读取当前项目配置
$ciConfigPath = Join-Path $rootPath "src" "ci-config.json"
$ciConfig = (Get-Content -Path $ciConfigPath -Encoding UTF8) | ConvertFrom-Json

$branchOrTagKey = 'branch'
if ($ciConfig.mode -eq 'tag') {
    $branchOrTagKey = 'tag'
}
$branchOrTag = $ciConfig.branch
$commit = $ciConfig.commit
$creationTime = $ciConfig.creationTime
$gitlabPipelineId = $ciConfig.gitlabPipelineId

$workflowUrl = "https://github.com/${env:repository}/actions/runs/${env:run_id}"
$pipelineUrl = "${env:GIT_REPO_PIPLINE}/${gitlabPipelineId}"

$noticeMsg = @"
--- ${currentDateStr} ---
${Msg}

--- build info ---
${branchOrTagKey}: ${branchOrTag}
commit: ${commit}
creationTime: ${creationTime}
github workflow: ${workflowUrl}
gitlab pipeline: ${pipelineUrl}
"@


# ----------------- 发送通知 -----------------
$body = @{
    msg_type = 'text'
    content  = @{
        text = $noticeMsg
    }
}

$bodyJson = ConvertTo-Json $body

Invoke-RestMethod `
    -Method 'Post' `
    -ContentType 'application/json' `
    -Uri $botUrl `
    -Body $bodyJson