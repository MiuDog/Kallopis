param(
	[switch] $UpdateGoldens
)

$ErrorActionPreference = 'Stop'

$projectRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$exampleRoot = Join-Path $projectRoot 'example'
$verificationFailures = [System.Collections.Generic.List[object]]::new()
$verificationSkipped = [System.Collections.Generic.List[object]]::new()
$verificationResults = @{}

# Flutter 與 Dart 必須來自同一套 SDK；直接沿用目前 PATH 選到的 Flutter，
# 不綁定任何開發者電腦的絕對路徑。
$flutterExecutable = (Get-Command flutter -ErrorAction Stop).Source
$flutterBin = Split-Path -Parent $flutterExecutable
$dartCandidate = Join-Path $flutterBin 'dart.bat'
$dartExecutable = if (Test-Path -LiteralPath $dartCandidate) {
	$dartCandidate
}
else {
	(Get-Command dart -ErrorAction Stop).Source
}

function Invoke-VerifyStep {
	param(
		[Parameter(Mandatory = $true)]
		[string] $Key,

		[Parameter(Mandatory = $true)]
		[string] $Name,

		[Parameter(Mandatory = $true)]
		[string] $WorkingDirectory,

		[Parameter(Mandatory = $true)]
		[string] $Executable,

		[Parameter(Mandatory = $true)]
		[string[]] $Arguments,

		[string[]] $DependsOn = @()
	)

	$blockedBy = @(
		$DependsOn | Where-Object {
			-not $verificationResults.ContainsKey($_) -or $verificationResults[$_] -ne 'passed'
		}
	)
	if ($blockedBy.Count -gt 0) {
		$verificationResults[$Key] = 'skipped'
		$verificationSkipped.Add(
			[pscustomobject]@{
				Name = $Name
				BlockedBy = $blockedBy -join ', '
			}
		)
		Write-Warning "$Name 因相依步驟未通過而停止：$($blockedBy -join ', ')"
		return
	}

	Write-Host "`n== $Name =="
	Push-Location -LiteralPath $WorkingDirectory

	try {
		# 直接執行外部工具，並立即保存它的原始結束碼。
		& $Executable @Arguments
		$stepExitCode = $LASTEXITCODE
	}
	finally {
		Pop-Location
	}

	if ($stepExitCode -ne 0) {
		$verificationResults[$Key] = 'failed'
		$verificationFailures.Add(
			[pscustomobject]@{
				Name = $Name
				ExitCode = $stepExitCode
			}
		)
		Write-Warning "$Name 失敗，結束碼：$stepExitCode；繼續執行其餘驗證。"
		return
	}

	$verificationResults[$Key] = 'passed'
}

# 依 CI 閘門順序涵蓋 root 與 example 的全部測試。同層級失敗不短路；只有
# 相依步驟失敗時才停止該分支，最後再一次彙整結果。
Invoke-VerifyStep -Key 'root_pub_get' -Name '根套件取得相依套件' -WorkingDirectory $projectRoot -Executable $flutterExecutable -Arguments @(
	'pub',
	'get'
)
Invoke-VerifyStep -Key 'example_pub_get' -Name '範例套件取得相依套件' -WorkingDirectory $exampleRoot -Executable $flutterExecutable -Arguments @(
	'pub',
	'get'
) -DependsOn @('root_pub_get')
Invoke-VerifyStep -Key 'format' -Name '格式檢查' -WorkingDirectory $projectRoot -Executable $dartExecutable -Arguments @(
	'format',
	'--output=none',
	'--set-exit-if-changed',
	'.'
)
Invoke-VerifyStep -Key 'root_analyze' -Name '根套件靜態分析' -WorkingDirectory $projectRoot -Executable $flutterExecutable -Arguments @(
	'analyze',
	'--fatal-infos'
) -DependsOn @('root_pub_get')
Invoke-VerifyStep -Key 'inventory' -Name '元件清單新鮮度' -WorkingDirectory $projectRoot -Executable $dartExecutable -Arguments @(
	'run',
	'tool/inventory.dart',
	'--check'
) -DependsOn @('root_pub_get')
Invoke-VerifyStep -Key 'example_analyze' -Name '範例套件靜態分析' -WorkingDirectory $exampleRoot -Executable $flutterExecutable -Arguments @(
	'analyze',
	'--fatal-infos'
) -DependsOn @('example_pub_get')

$testArguments = @('test')
if ($UpdateGoldens) {
	$testArguments += '--update-goldens'
}

Invoke-VerifyStep -Key 'root_test' -Name '根套件全部測試（含 golden）' -WorkingDirectory $projectRoot -Executable $flutterExecutable -Arguments $testArguments -DependsOn @('root_pub_get')
Invoke-VerifyStep -Key 'example_test' -Name '範例套件全部測試（含 golden）' -WorkingDirectory $exampleRoot -Executable $flutterExecutable -Arguments $testArguments -DependsOn @('example_pub_get')

if ($verificationFailures.Count -gt 0) {
	Write-Host "`nKallopis 全量驗證完成，但有 $($verificationFailures.Count) 個步驟失敗："
	foreach ($failure in $verificationFailures) {
		Write-Host "- $($failure.Name)（結束碼 $($failure.ExitCode)）"
	}
	if ($verificationSkipped.Count -gt 0) {
		Write-Host "因相依失敗而停止的步驟："
		foreach ($skipped in $verificationSkipped) {
			Write-Host "- $($skipped.Name)（相依：$($skipped.BlockedBy)）"
		}
	}
	exit 1
}

Write-Host "`nKallopis 全量驗證全部通過。"
