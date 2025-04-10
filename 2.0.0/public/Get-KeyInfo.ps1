Function Get-KeyInfo {
  <#
    .SYNOPSIS
    Get a key's information.
    .DESCRIPTION
    Get a pressed key's information object.
    .EXAMPLE
    PS> Get-KeyInfo
    >>>>>>>>
    KeyChar Key Modifiers
    ------- --- ---------
          l   L      None
    .EXAMPLE
    PS> $key = Get-KeyInfo
    >>>>
    PS> $key
    KeyChar Key Modifiers
    ------- --- ---------
              L   Control
    PS> $key.Modifiers
    Control        
  #>
  do {
    if ([Console]::KeyAvailable) {
      $keyObject = [Console]::ReadKey($true)
      break
    }
    Write-Host '>' -NoNewline
    Start-Sleep -Seconds 1
  } while ($true)
  Write-Host
  $keyObject
}
Set-Alias -Name 'gki'`
          -Value 'Get-KeyInfo'`
          -Description 'Get a pressed key''s information object.'