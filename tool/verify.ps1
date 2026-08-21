$ErrorActionPreference = 'Stop'

$flutterBin = 'C:\development\flutter\bin'
$projectRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$exampleRoot = Join-Path $projectRoot 'example'

# 先固定專案已驗證的 Flutter 工具鏈，避免誤用其他安裝版本。
$env:Path = "$flutterBin;$env:Path"

function Invoke-VerifyStep {
	param(
		[Parameter(Mandatory = $true)]
		[string] $Name,

		[Parameter(Mandatory = $true)]
		[string] $WorkingDirectory,

		[Parameter(Mandatory = $true)]
		[string] $Executable,

		[Parameter(Mandatory = $true)]
		[string[]] $Arguments
	)

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
		Write-Error "$Name 失敗，結束碼：$stepExitCode" -ErrorAction Continue
		exit $stepExitCode
	}
}

# 依 CI 閘門順序執行；任一步驟失敗都會立即停止。
Invoke-VerifyStep -Name '格式檢查' -WorkingDirectory $projectRoot -Executable 'dart' -Arguments @(
	'format',
	'--output=none',
	'--set-exit-if-changed',
	'.'
)
Invoke-VerifyStep -Name '根套件靜態分析' -WorkingDirectory $projectRoot -Executable 'flutter' -Arguments @(
	'analyze',
	'--fatal-infos'
)
Invoke-VerifyStep -Name '元件清單新鮮度' -WorkingDirectory $projectRoot -Executable 'dart' -Arguments @(
	'run',
	'tool/inventory.dart',
	'--check'
)
Invoke-VerifyStep -Name '根套件測試' -WorkingDirectory $projectRoot -Executable 'flutter' -Arguments @(
	'test'
)
Invoke-VerifyStep -Name '範例套件靜態分析' -WorkingDirectory $exampleRoot -Executable 'flutter' -Arguments @(
	'analyze',
	'--fatal-infos'
)
Invoke-VerifyStep -Name '範例套件測試' -WorkingDirectory $exampleRoot -Executable 'flutter' -Arguments @(
	'test'
)
