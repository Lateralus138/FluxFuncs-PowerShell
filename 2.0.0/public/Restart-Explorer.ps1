Function Restart-Explorer {
  <#
  .SYNOPSIS
  Restart Windows Explorer.
  .DESCRIPTION
  Restart Windows Explorer.
  .EXAMPLE
  PS> Restart-Explorer
  Restarting Explorer.
  Attempting to stop Explorer.
  Attempting to start Explorer.
  Explorer restarted successfully.
  #>
  Write-Host "Restarting Explorer.`nAttempting to stop Explorer."
  Start-Process -Path 'C:\Windows\System32\taskkill.exe' -ArgumentList '/im Explorer.exe /f' -Verb RunAs -Wait -ErrorVariable Error 2>&1 | Out-Null
  if ($error_.Count -eq 1) {
    $global:LASTEXITCODE = 255
    Write-Error($error_.Message)
    return
  }
  Write-Host "Attempting to start Explorer."
  Start-Process -Path 'C:\Windows\Explorer.exe' -ErrorVariable Error 2>&1 | Out-Null
  if ($error_.Count -eq 1) {
    $global:LASTEXITCODE = 254
    Write-Error($error_.Message)
    return
  }
  Write-Host "Explorer restarted successfully."
}