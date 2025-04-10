Function Get-FullPaths() {
  <#
    .SYNOPSIS
    Get the full paths of all files and/or directories in a directory.
    .DESCRIPTION
    Get the full paths of all files and/or dirctories in a directory with a few
    options such as directories or files only and recursive and depth.
    .PARAMETER Path
    The parent path to query.
    .PARAMETER File
    Files only.
    .PARAMETER Directory
    Directories only.
    .PARAMETER Recurse
    Query parent path recursively.
    .PARAMETER Depth
    The depth of recursiveness.
    .INPUTS
    Pipeline. Directory paths only.
    .OUTPUTS
    System.Object:String. List of full paths.
    .EXAMPLE
    PS> Get-FullPaths -Path ~\test
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
    .EXAMPLE
    PS> Get-FullPaths -Path ~\test -File
    C:\Users\<USER>\test\a.txt
    C:\Users\<USER>\test\b.txt
    C:\Users\<USER>\test\c.txt
    C:\Users\<USER>\test\d.txt
    C:\Users\<USER>\test\e.txt
    C:\Users\<USER>\test\f.txt
    .EXAMPLE
    PS> Get-FullPaths -Path .\test\ -Recurse
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
    C:\Users\<USER>\test\a\a.txt
    C:\Users\<USER>\test\a\b.txt
    C:\Users\<USER>\test\a\c.txt
    C:\Users\<USER>\test\a\d.txt
    C:\Users\<USER>\test\a\e.txt
    C:\Users\<USER>\test\a\f.txt
  #>
  [CmdletBinding()]
  Param(
    [ValidateScript({Test-Path $_ -PathType Container})]
    [String]$Path,
    [Switch]$File,
    [Switch]$Directory,
    [Switch]$Recurse,
    [Int]$Depth,
    [Parameter(ValueFromPipeline)]
    [ValidateScript({Test-Path $_ -PathType Container})]
    [String]$PathFromPipe
  )
  begin {
    $args_ = @{}
    if ($PSBoundParameters.ContainsKey('File')) {
      $args_['File'] = $true
    }
    if ($PSBoundParameters.ContainsKey('Directory')) {
      $args_['Directory'] = $true
    }
    if ($PSBoundParameters.ContainsKey('Recurse')) {
      $args_['Recurse'] = $true
      if ($PSBoundParameters.ContainsKey('Depth')) {
        $args_['Depth'] = $Depth
      }
    }
    if ($PSBoundParameters.ContainsKey('Path')) {
      (Get-ChildItem -Path $Path @args_).FullName
    }
  }
  process {
    if ($PSBoundParameters.ContainsKey('PathFromPipe')) {
      (Get-ChildItem -Path $PathFromPipe @args_).FullName
    } else {
      if (-not ($PSBoundParameters.ContainsKey('Path'))) {
        (Get-ChildItem -Path . @args_).FullName
      }
    }
  }
}
Set-Alias -Name 'gfp'`
          -Value 'Get-FullPaths'`
          -Description 'Get the full paths of all files and/or directories in a directory with a few options such`nas directories or files only and recursive and depth.'