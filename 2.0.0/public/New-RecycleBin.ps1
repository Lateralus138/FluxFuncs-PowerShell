Function New-RecycleBin() {
  <#
  .SYNOPSIS
    Create the Recycle Bin directory. 
  .DESCRIPTION
    Create the Recycle Bin directory in Windows.
  .PARAMETER Path
    The directory where the directory should be created. Defaults to '.\'.
  .PARAMETER Name
    The name of the directory. Defaults to 'Recycle Bin'..
  .EXAMPLE
    CreateRecycleBin
  .EXAMPLE
    CreateRecycleBin -Path $Env:USERPROFILE\Desktop
  .NOTES
    New-RecycleBin.psm1
    Author: Ian Pride 
    Modified date: 118:59:28 UTC - Feb 28, 2025
    Version 1.0.0 - Added Get-Help comments
  #>
  Param
  (
    [String]$Path = '.\',
    [String]$Name = 'Recycle Bin'
  )
  try {
    New-Item -Path "$Path" -Name "$Name.{645FF040-5081-101B-9F08-00AA002F954E}" -ItemType Directory -ErrorVariable NewError -ErrorAction SilentlyContinue
    if ($NewError) {
      throw $NewError
    }
  }
  catch {
    $global:LASTEXITCODE = 255
    Write-Error $NewError.Exception
    Write-Error "$Path\$Name cannot be created."
    return
  }
}