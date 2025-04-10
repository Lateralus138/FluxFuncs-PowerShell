Function New-Autorun() {
  <#
    .SYNOPSIS
    Create a new Autorun.inf file.
    .DESCRIPTION
    Create a basic Autorun file especially for ISO containers.
    .PARAMETER Path
    Directory where the file will be created.
    .PARAMETER Open
    Path to program to run.
    .PARAMETER Icon
    Path to an icon.
    .PARAMETER Label
    Label string to display.
    .PARAMETER Overwrite
    Overwrite the file if it exists. The is false by default.
    .EXAMPLE
    PS> $params = @{
    >'Path' = 'C:\path\to\program';
    >'Open' = 'program.exe';
    >'Icon' = 'program.ico';
    >'Label' = 'Program'
    >}
    PS> New-Autorun @params
  #>
  Param(
    [String]$Path = '.',
    [String]$Open = '',
    [String]$Icon = '',
    [String]$Label = '',
    [Switch]$Overwrite
  )
  $Name = 'Autorun.inf'
  $File = "${Path}\${Name}"
  $File = $File.Replace("\\", "\")
  $content = "open=$Open`nicon=$Icon`nlabel=$Label"
  if (-not (Test-Path "${File}" -PathType Leaf 2>&1)) {
    try {
      New-Item -Path "$Path" -Name "$Name" -ErrorVariable NewError -ErrorAction SilentlyContinue
      if ($NewError) {
        throw $NewError
      }
    }
    catch {
      $global:LASTEXITCODE = 255
      Write-Error $NewError.Exception
      Write-Error "$File cannot be created."
      return
    }
  }
  else {
    if ($Overwrite) {
      $content | Out-File -FilePath "$File"
    }
    return
  }
  $content | Out-File -FilePath "$File"
}