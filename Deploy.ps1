[CmdletBinding()]
Param(
  [Parameter(Position = 0, Mandatory)]
  [ValidateNotNull()]
  [Alias("Version")]
  [version]$BuildVersion
  ,
  [Parameter(Position = 1, Mandatory)]
  [ValidateNotNullOrEmpty()]
  [string]$Repository
  ,
  [Parameter()]
  [ValidateNotNullOrEmpty()]
  [string]$ImageName = "sitecore-xc-xp0"
)
$ErrorActionPreference = "Stop"

$pushArgs = @("push", "${Repository}/${ImageName}:${BuildVersion}")
& docker $pushArgs
Write-Output "Push ${Repository}/${ImageName}:${BuildVersion} complete."