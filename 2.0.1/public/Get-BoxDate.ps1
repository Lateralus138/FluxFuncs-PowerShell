Function Get-BoxDate() {
  <#
  .SYNOPSIS
  Get the current date and time in a box.
  .DESCRIPTION
  Get the current date and time in a box with various options.
  .PARAMETER Style
  Set the box style from the following options: Single, Double, SingleDouble,
  and DoubleSingle. Single and Double are self-explanatory, but SingleDouble
  means that vertical lines are singles and horizontal lines or doubles and
  vice versa for DoubleSingle.
  .PARAMETER Utc
  Date and time is Universal Coordinated Time. Default is local.
  .EXAMPLE
  PS> Get-BoxDate
  ┌────────────────────────────────────┐
  │ Friday, March 14, 2025 12:33:21 PM │
  └────────────────────────────────────┘
  .EXAMPLE
  PS> 'Single','Double','SingleDouble','DoubleSingle' | % { $_; $(Get-BoxDate -Style $_) }
  Single
  ┌───────────────────────────────────┐
  │ Friday, March 14, 2025 1:03:41 PM │
  └───────────────────────────────────┘
  Double
  ╔═══════════════════════════════════╗
  ║ Friday, March 14, 2025 1:03:41 PM ║
  ╚═══════════════════════════════════╝
  SingleDouble
  ╒═══════════════════════════════════╕
  │ Friday, March 14, 2025 1:03:41 PM │
  ╘═══════════════════════════════════╛
  DoubleSingle
  ╓───────────────────────────────────╖
  ║ Friday, March 14, 2025 1:03:41 PM ║
  ╙───────────────────────────────────╜
  .EXAMPLE
  PS> Get-BoxDate; Get-BoxDate -Utc
  ┌───────────────────────────────────┐
  │ Friday, March 14, 2025 1:07:16 PM │
  └───────────────────────────────────┘
  ┌───────────────────────────────────┐
  │ Friday, March 14, 2025 6:07:16 PM │
  └───────────────────────────────────┘
  #>
  [CmdletBinding()]
  Param(
    [ValidateSet('Single', 'Double', 'SingleDouble', 'DoubleSingle')]
    [String]$Style = 'single',
    [Switch]$Utc
  )
  switch ($Utc) {
    $true { $date_ = [String](Get-Date -Date $(Get-Date) -AsUTC).DateTime }
    default { $date_ = [String](Get-Date -Date $(Get-Date)).DateTime }
  }
  $single = @{
    'horizontal' = [char]0x2500
    'vertical'   = [char]0x2502
    'upperleft'  = [char]0x250C
    'upperright' = [char]0x2510
    'lowerleft'  = [char]0x2514
    'lowerright' = [char]0x2518
  }
  $double = @{
    'horizontal' = [char]0x2550
    'vertical'   = [char]0x2551
    'upperleft'  = [char]0x2554
    'upperright' = [char]0x2557
    'lowerleft'  = [char]0x255A
    'lowerright' = [char]0x255D
  }
  $singledouble = @{
    'horizontal' = [char]0x2550
    'vertical'   = [char]0x2502
    'upperleft'  = [char]0x2552
    'upperright' = [char]0x2555
    'lowerleft'  = [char]0x2558
    'lowerright' = [char]0x255B
  }
  $doublesingle = @{
    'horizontal' = [char]0x2500
    'vertical'   = [char]0x2551
    'upperleft'  = [char]0x2553
    'upperright' = [char]0x2556
    'lowerleft'  = [char]0x2559
    'lowerright' = [char]0x255C
  }
  switch ($Style) {
    'double' { $box = $double }
    'singledouble' { $box = $singledouble }
    'doublesingle' { $box = $doublesingle }
    default { $box = $single }
  }
  for ($index = 0; $index -lt ($date_.ToString().Length + 2); $index++) {
    $line = "$line" + $box.horizontal
  }
  $box.upperleft + $line + $box.upperright + "`n" +
  $box.vertical + " " + $date_.ToString() + " " + $box.vertical + "`n" +
  $box.lowerleft + $line + $box.lowerright
}
Set-Alias -Name 'gbd'`
          -Value 'Get-BoxDate'`
          -Description 'Get the current date and time in a box.'