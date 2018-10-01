[CmdletBinding()]
Param(
  [Parameter(Position = 0, Mandatory)]
  [ValidateNotNull()]
  [Alias("Version")]
  [version]$BuildVersion
)
$ErrorActionPreference = "Stop"

Write-Output "Build v${BuildVersion} complete."