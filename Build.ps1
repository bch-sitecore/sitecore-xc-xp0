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

$buildArgs = @(
  "build",
  "-t", "${ImageName}:${BuildVersion}",
  "-t", "${ImageName}:latest",
  "."
)
& docker $buildArgs
Write-Output "Build ${ImageName}:${BuildVersion} complete."