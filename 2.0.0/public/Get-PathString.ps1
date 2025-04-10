Function Get-PathString() {
  <#
  .SYNOPSIS
  Get a string from Resolve-Path.
  .DESCRIPTION
  Get strings from paths using Resolve-Path.
  .INPUTS
  Pipeline. Directory or file paths.
  .OUTPUTS
  System.Object:String. List of paths.
  .EXAMPLE
  PS> Get-PathString
  C:\Users\<USER>
  .EXAMPLE
  PS> ls .\test | Get-PathString
  C:\Users\<USER>\test\a
  C:\Users\<USER>\test\b
  C:\Users\<USER>\test\c
  C:\Users\<USER>\test\d
  C:\Users\<USER>\test\e
  C:\Users\<USER>\test\f
  C:\Users\<USER>\test\a.txt
  C:\Users\<USER>\test\b.txt
  C:\Users\<USER>\test\c.txt
  C:\Users\<USER>\test\d.txt
  C:\Users\<USER>\test\e.txt
  C:\Users\<USER>\test\f.txt
  #>
  [CmdletBinding()]
  Param(
    [ValidateScript({Test-Path $_})]
    [String]$Path,
    [Parameter(ValueFromPipeline)]
    [ValidateScript({Test-Path $_})]
    [String]$PathFromPipe
  )
  begin {
    $rp = {
      Param([String]$Path)
      Resolve-Path -Path "$Path" | Select-Object -ExpandProperty path
    }
    if ($PSBoundParameters.ContainsKey('Path')) {
      &$rp -Path "$Path"
    }
  }
  process {
    if ($PSBoundParameters.ContainsKey('PathFromPipe')) {
      &$rp -Path "$PathFromPipe"
    } else {
      if (-not ($PSBoundParameters.ContainsKey('path'))) {
        &$rp -Path .
      }
    }
  }
}