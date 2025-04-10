function Get-AreaOfCircle() {
  <#
  .SYNOPSIS
  Get the area of a circle.
  .DESCRIPTION
  Get the area of a circle by radius or diameter.
  .PARAMETER Value
  Value by radius or diameter. Value is assumed to be a radius unless the ByDaimeter switch is passed.
  .PARAMETER Precision
  Rounding precision of the output.
  .PARAMETER ByDiameter
  Value is by diameter. Defaults to radius.
  .EXAMPLE
  PS> Get-AreaOfCircle 60
  11310
  .EXAMPLE
  PS> Get-AreaOfCirle 60 -ByDiameter
  2827
  #>
  Param(
    [Parameter(Mandatory = $true)]
    [Double]$Value,
    [ValidateRange(0, 15)]
    [Int]$Precision,
    [Switch]$ByDiameter
  )
  switch ($ByDiameter) {
    $true { [Math]::Round([Math]::PI * [Math]::Pow($Value / 2, 2), $Precision) }
    default { [Math]::Round([Math]::PI * [Math]::Pow($Value, 2), $Precision) }
  }
}
Set-Alias -Name 'gaoc' -Value 'Get-AreaOfCircle' -Description 'Get the area of a circle.'