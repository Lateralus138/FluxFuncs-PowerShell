Function Convert-DecimalToHexadecimal() {
  <#
    .SYNOPSIS
    Convert decimal integers to hexadecimal format.
    .Description
    Convert decimal integers to hexadecimal format with a few options.
    .PARAMETER Decimal
    Decimal integer value to convert to hexadecimal.
    .PARAMETER Length
    Length of zero padding.
    .PARAMETER Prefix
    Prefix hex value with 0x, #, or anything other string.
    .PARAMETER Uppercase
    Force hexadecimal value ot be uppercase.
    .EXAMPLE
    PS> Convert-DecimalToHexadecimal 32 -Prefix 0x -Uppercase
    0x20
    .EXAMPLE
    PS> 16..31 | Convert-DecimalToHexadecimal -Decimal 255 -Prefix 0x -Uppercase -Length 8
    0x000000FF
    0x00000010
    0x00000011
    0x00000012
    0x00000013
    0x00000014
    0x00000015
    0x00000016
    0x00000017
    0x00000018
    0x00000019
    0x0000001A
    0x0000001B
    0x0000001C
    0x0000001D
    0x0000001E
    0x0000001F
  #>
  [CmdletBinding()]
  Param(
    [Parameter(ValueFromPipeline)]
    [Int64]$DecimalFromPipe,
    [Int64]$Decimal,
    [Int]$Length = 0,
    [ArgumentCompletions('0x', '#')]
    [String]$Prefix = '',
    [Switch]$Uppercase
  )
  begin {
    switch ($Uppercase) {
      True { $case = 'X' };
      default { $case = 'x' }
    }
    switch ($Length) {
      { $_ -le 0 } { $width = '' }
      default { $width = [String]($Length) }
    }
    if ($PSBoundParameters.ContainsKey('Decimal')) {
      $Prefix + "{0:${case}${width}}" -f $Decimal
    }
  }
  process {
    $Prefix + "{0:${case}${width}}" -f $DecimalFromPipe
  }
}
Set-Alias -Name 'dectohex'`
          -Value 'Convert-DecimalToHexadecimal'`
          -Description 'Convert decimal integers to hexadecimal format.'