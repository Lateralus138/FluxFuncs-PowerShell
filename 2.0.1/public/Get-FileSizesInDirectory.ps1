Function Get-FileSizesInDirectory
{
  <#
  .SYNOPSIS
  Get the combined size of all files in a directory.
  .DESCRIPTION
  Get the combined size of all files in a directory or directories recursively.
  .PARAMETER Path
  Root directory of file[s]. Defaults to '.\'.
  .PARAMETER SizeType
  Get the size in Kilobytes(KB), Megabytes(MB), Gigabytes(GB), or Terabytes(TB).
  .PARAMETER Round
  Precision of rounding from 0-15.
  .PARAMETER Recurse
  Recurse directories instead of the parent directory only.
  #>
  Param(
    [ValidateScript({Test-Path $_ -PathType Container})]
    [String]$Path = '.\',
    [ValidateSet("KB", "MB", "GB", "TB")]
    [String]$SizeType = "KB",
    [ValidateRange(0, 15)]
    [Int]$Round = 2,
    [Switch]$Recurse
  )
  $Type = "1${SizeType}"
  $args_ = @{
    'Path'        = "$Path";
    'File'        = $true;
    'ErrorAction' = 'SilentlyContinue'
  }
  if ($Recurse)
  {
    $args['Recurse'] = $true
    $args['Hidden'] = $true
  }
  [Float]$value1 = "$([Math]::Round($(((Get-ChildItem @args_ | Measure-Object -Property Length -sum).Sum)/$Type), $Round))"
  [Float]$value2 = "$([Math]::Round($(((Get-ChildItem @args_ | Measure-Object -Property Length -sum).Sum)/$Type), $Round))"
  [Float]$result = $([Float]$value1 + [Float]$value2)
  "$result" + $Type.SubString(1)
}
Set-Alias -Name 'gfsid'`
          -Value 'Get-FileSizesInDirectory'`
          -Description 'Get the combined size of all files in a directory or directories recursively.'