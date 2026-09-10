param(
    [switch] $UpdateGoldens
)

$ErrorActionPreference = 'Stop'

$projectRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$exampleRoot = Join-Path $projectRoot 'example'

function Invoke-FlutterStep {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Name,

        [Parameter(Mandatory = $true)]
        [string] $WorkingDirectory,

        [Parameter(Mandatory = $true)]
        [string[]] $Arguments
    )

    Write-Host "`n== $Name =="
    Push-Location -LiteralPath $WorkingDirectory

    try {
        flutter @Arguments
        $stepExitCode = $LASTEXITCODE
    }
    finally {
        Pop-Location
    }

    if ($stepExitCode -ne 0) {
        throw "$Name 失敗，結束碼：$stepExitCode"
    }
}

# 只收斂 panel padding 契約直接涵蓋的分析、幾何與視覺回歸。
Invoke-FlutterStep -Name 'Kallopis 靜態分析' -WorkingDirectory $projectRoot -Arguments @(
    'analyze'
)

Invoke-FlutterStep -Name 'Panel padding 元件測試' -WorkingDirectory $projectRoot -Arguments @(
    'test',
    'test/klp_workbench_shell_padding_test.dart',
    'test/klp_stage_header_wrapping_test.dart',
    'test/klp_stage_header_test.dart',
    'test/consumer_contract_test.dart',
    '--reporter',
    'expanded'
)

$goldenArguments = @(
    'test',
    'test/catalog_golden_test.dart',
    '--plain-name',
    'Sidebar Shell',
    '--reporter',
    'expanded'
)

if ($UpdateGoldens) {
    $goldenArguments = @('test', '--update-goldens') + $goldenArguments[1..($goldenArguments.Length - 1)]
}

Invoke-FlutterStep -Name 'Sidebar Shell golden' -WorkingDirectory $exampleRoot -Arguments $goldenArguments

Write-Host "`nPanel padding 驗證全部通過。"
