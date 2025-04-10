
Function Get-AppPackageNames() {
  <#
  .SYNOPSIS
  Get App Package names only.
  .DESCRIPTION
  Get App Package names only. This is just a shortcut to:
  @(Get-AppPackage | ForEach-Object { $_.Name })
  #>
  @(Get-AppPackage | ForEach-Object { $_.Name })
}