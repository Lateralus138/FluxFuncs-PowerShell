function Add-EscapedQuotes() {
  <#
  .SYNOPSIS
  Wrap strings in escaped quotes.
  .DESCRIPTION
  Wrap strings in escaped single or double quotation marks.
  .PARAMETER String
  The string ot wrap. This can be an empty string.
  .PARAMETER Single
  Use single quotes. Defaults to double.
  .EXAMPLE
  PS> Add-EscapedQuotes 'This is a string in escaped double quotes.'
  \"This is a string in escaped double quotes.\"
  .EXAMPLE
  PS> Add-EscapedQuotes 'This is a string in escaped single quotes.' -Single  
  \'This is a string in escaped single quotes.\'
  .INPUTS
  System.Object:String
  .OUTPUTS
  System.Object:String
  #>
  [CmdletBinding()]
  Param(
    [String]$String,
    [Switch]$Single,
    [Parameter(ValueFromPipeline)]
    [String]$StringFromPipe
  )
  begin {
    switch ($Single) {
      $true { $qt = '\''' }
      default { $qt = '\"' }
    }
    $quote = {
      Param([String]$string_)
      $string_.Replace('"', '').Replace('''', '') > $null
      $qt + $string_ + $qt
    }
    if ($PSBoundParameters.ContainsKey('String')) {
      &$quote $String
    }
  }
  process {
    switch ($PSBoundParameters.ContainsKey('StringFromPipe')) {
      $true { &$quote $StringFromPipe }
      default { if (-not ($PSBoundParameters.ContainsKey('String'))) { &$quote '' } }
    }
  }
}