[CmdletBinding()]
Param()
$ErrorActionPreference = "Stop"

Function ConvertTo-PrettyJson {
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory, ValueFromPipeline)]
    [String] $json
  )
  Process {
    $indent = 0;
    ($json -Split '\n' |
      % {
        if ($_ -match '[\}\]],?\s*$') {
          # This line contains  ] or }, decrement the indentation level
          $indent--
        }
        $line = (' ' * $indent * 2) + $_.TrimStart().Replace(':  ', ': ')
        if ($_ -match '[\{\[]\s*$') {
          # This line contains [ or {, increment the indentation level
          $indent++
        }
        $line
    }) -Join "`n"
  }
}

$destPath = [System.IO.Path]::GetFullPath( (Join-Path $PSScriptRoot -ChildPath "..\dist") )
$configSourcePath = Join-Path $PSScriptRoot -ChildPath "SIF.Config"
$moduleSourcePath = Join-Path $PSScriptRoot -ChildPath "SIF.Module"
$moduleDestFile = Join-Path $destPath -ChildPath "SIF.Module.ps1"

Write-Output "Linting scripts"
Invoke-ScriptAnalyzer $moduleSourcePath -Recurse -Fix

Write-Output "Cleaning ${destPath}"
If (Test-Path $destPath) {
  Remove-Item $destPath -Recurse
}

Write-Output "Creating ${destPath}"
New-Item $destPath -ItemType Directory | Out-Null

Write-Host "Creating ${moduleDestFile}"
@"
#
# SIF.Module
# File auto-generated on $((Get-Date).ToString('F'))
#
"@ | Set-Content $moduleDestFile
Get-ChildItem $moduleSourcePath -Include "*.ps1" -Exclude "*.Tests.ps1" -Recurse | ForEach-Object {
  $name = $_.Name

  "<# ${name} #>" | Add-Content $moduleDestFile
  Get-Content $_.FullName | Add-Content $moduleDestFile
}

Write-Output "Copying (and linting) configuration files"
Get-ChildItem $configSourcePath -Include "*.json" -Recurse | ForEach-Object {
  $name = $_.Name

  Try {
    $content = Get-Content $_.FullName | ConvertFrom-Json
  } Catch {
    Write-Error "${name}: Invalid or malformed JSON" -ErrorAction SilentlyContinue
    Write-Error $_.Exception.Message -ErrorAction SilentlyContinue
    Write-Error $_.Exception.StackTrace -ErrorAction SilentlyContinue
    Throw
  }

  If (!($content.PSObject.Properties -contains 'Modules')) {
    $content | Add-Member NoteProperty "Modules" @()
  }
  $content.Modules += ".\{0}" -f (Split-Path $moduleDestFile -Leaf)

  $content | ConvertTo-Json | ConvertTo-PrettyJson | Set-Content (Join-Path $destPath -ChildPath $_.Name)

  #Copy-Item $_.FullName -Destination $destPath
}

Write-Output "Source build complete."