Function Remove-EmptyDirectories() {
  <#
  .SYNOPSIS
    Remove empty directories.
  .DESCRIPTION
    Remove empty directories from a path. Recursive by default.
  .PARAMETER Path
    The working root path. Defaults to '.'
  .PARAMETER Recurse
    Recurse into sub directories. $true by default.
  .EXAMPLE
    Remove-EmptyDirectories -Path 'C:\'
  .EXAMPLE
    Remove-EmptyDirectories -Recurse $false
  .NOTES
    Remove-EmptyDirectories.ps1
    Author: Ian Pride 
    Modified date: 14:43:34 UTC - Apr 7, 2025
    Version 1.0.0 - Renamed to a verb approved appropriate name.
  #>
  Param(
    [ValidateScript( { $_.Length -ne 0 -and (Test-Path -Path $_ -PathType Container) } )]
    [String]$Path = '.',
    [Switch]$Recurse
  )
  switch ($Recurse) {
    $true { $directories = Get-ChildItem -Path "$Path" -Recurse -Directory }
    default { $directories = Get-ChildItem -Path "$Path" -Directory }
  }
 $directories |
  ForEach-Object {
    if ( (Get-ChildItem $_.FullName | Measure-Object | Select-Object -ExpandProperty Count) -eq 0) {
      Remove-Item -Force -Recurse $_.FullName
    }
  }
}