Function Get-Parent() {
  <#
  .SYNOPSIS
  Get an object of an path with an object of it's parent.
  .DESCRIPTION
  Get an object of an path with an object of it's parent.
  .PARAMETER Path
  A single file or directory path.
  .INPUTS
  Pipeline. Directory or file paths.
  .OUTPUTS
  System.Array:Object[]. Arrays of paths.
  .EXAMPLE
  PS> Get-Parent
  Name                           Value
  ----                           -----
  Path                           .
  Parent                         C:\Users
  .EXAMPLE
  PS> $parent = Get-Parent
  PS> $parent.Parent.Path
  C:\Users
  .EXAMPLE
  PS> Get-ChildItem .\test | Get-Parent
  Name                           Value
  ----                           -----
  Path                           C:\Users\<USER>\test\a
  Parent                         C:\Users\<USER>\test
  Path                           C:\Users\<USER>\test\b
  Parent                         C:\Users\<USER>\test
  Path                           C:\Users\<USER>\test\c
  Parent                         C:\Users\<USER>\test
  Path                           C:\Users\<USER>\test\d
  Parent                         C:\Users\<USER>\test
  Path                           C:\Users\<USER>\test\e
  Parent                         C:\Users\<USER>\test
  Path                           C:\Users\<USER>\test\f
  Parent                         C:\Users\<USER>\test
  Path                           C:\Users\<USER>\test\a.txt
  Parent                         C:\Users\<USER>\test
  Path                           C:\Users\<USER>\test\b.txt
  Parent                         C:\Users\<USER>\test
  Path                           C:\Users\<USER>\test\c.txt
  Parent                         C:\Users\<USER>\test
  Path                           C:\Users\<USER>\test\d.txt
  Parent                         C:\Users\<USER>\test
  Path                           C:\Users\<USER>\test\e.txt
  Parent                         C:\Users\<USER>\test
  Path                           C:\Users\<USER>\test\f.txt
  Parent                         C:\Users\<USER>\test
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
    $func = {
      Param([String]$Path)
      switch (Test-Path -Path "$Path" -Type Leaf) {
        $true {
          @{
            'Path' = "$Path";
            'Parent' = Resolve-Path -Path (Get-ChildItem -Path "$Path").Directory
          }
        }
        default {
          @{
            'Path' = "$Path";
            'Parent' = Resolve-Path -Path (Get-Item -Path "$Path").Parent
          }          
        }
      }
    }
    if ($PSBoundParameters.ContainsKey('Path')) {
      &$func -Path "$Path"
    }
  }
  process {
    if ($PSBoundParameters.ContainsKey('PathFromPipe')) {
      &$func -Path "$PathFromPipe"
    } else {
      if (-not ($PSBoundParameters.ContainsKey('Path'))) {
        &$func -Path .
      }
    }
  }
}