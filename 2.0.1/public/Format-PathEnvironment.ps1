Function Format-PathEnvironment() {
  <#
  .SYNOPSIS
    Print the $Env:PATH variable.
  .DESCRIPTION
    Print the $Env:PATH variable split by the ';' delimeter.
  .EXAMPLE
    WTTR_CLI -Location 'Decatur,Illinois' -Format '%t'
  .EXAMPLE
  PS> Format-PathEnvironment
  C:\Program Files\PowerShell\7
  C:\Program Files (x86)\VMware\VMware Workstation\bin\
  C:\Program Files (x86)\oh-my-posh\bin\
  C:\Program Files\ImageMagick-7.1.1-Q16-HDRI
  C:\WINDOWS\system32
  C:\WINDOWS
  C:\WINDOWS\System32\Wbem
  C:\WINDOWS\System32\WindowsPowerShell\v1.0\
  C:\WINDOWS\System32\OpenSSH\
  C:\Program Files\Neovim\bin
  C:\Program Files\WezTerm
  C:\Program Files\PowerShell\7\
  ...
  .NOTES
    Format-PathEnvironment.ps1
    Author: Ian Pride 
    Modified date: 02:29:42 UTC - Apr 7, 2025
    Version 1.0.0 - Added Get-Help comments
  #>
  $Env:PATH -split ';'
}