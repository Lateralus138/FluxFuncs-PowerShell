Function Get-DiffUnique() {
  <#
  .SYNOPSIS
    Print differences in two files.
  .DESCRIPTION
    Print unique differences in two files with Compare-Object and Format-List.
  .PARAMETER FileA
    The path of the 1st file.
  .PARAMETER FileB
    The path of the 2nd file.
  .EXAMPLE
    DiffUnique -FileA .\filea.txt -FileB .\fileb.txt
  .EXAMPLE
    DiffUnique .\filea.txt .\fileb.txt
  .NOTES
    Get-DiffUnique.psm1
    Author: Ian Pride 
    Modified date: 16:35:38 UTC - Mar 1, 2025
    Version 1.0.0 - Added Get-Help comments
  #>
  [CmdletBinding()]
  Param(
    [ValidateScript({Test-Path $_ -PathType Leaf})]
    [Parameter(Mandatory)][String]$FileA,
    [ValidateScript({Test-Path $_ -PathType Leaf})]
    [Parameter(Mandatory)][String]$FileB
  )
  Compare-Object (Get-Content "$FileA") (Get-Content "$FileB") | Format-List
}
Set-Alias -Name 'gdu'`
          -Value 'Get-DiffUnique'`
          -Description 'Print unique differences in two files with Compare-Object and Format-List.'