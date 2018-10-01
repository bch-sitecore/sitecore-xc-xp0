[CmdletBinding()]
Param(
  [Parameter(Position = 0, Mandatory)]
  [ValidateNotNull()]
  [Alias("Version")]
  [version]$BuildVersion
  ,
  [Parameter()]
  [ValidateNotNullOrEmpty()]
  [string]$ImageName = "sitecore-xc-xp0"
  ,
  [Parameter()]
  [AllowEmptyString()]
  [string]$Repository
)
$ErrorActionPreference = "Stop"

If ($Repository) {
  $ImageName = "${Repository}/${ImageName}"
}

Write-Output "Build ${ImageName}:${BuildVersion} complete."