Function ConvertTo-PrettyJson {
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory, ValueFromPipeline)]
    [String]$Json
  )
  Process {
    $indent = 0;
    ($Json -split "`n" | ForEach-Object {
      If ($_ -match "[\}\]],?\s*$") {
        $indent--
      }
      $line = (" " * $indent * 2) + $_.TrimStart().Replace(":  ", ": ")
      If ($_ -match "[\{\[]\s*$") {
        $indent++
      }
      $line
    }) -Join "`n"
  }
}