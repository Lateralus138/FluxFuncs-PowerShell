Function SetConsole
{
  Param ([String]$Title = $(Get-Date))
  $Host.UI.RawUI.WindowTitle = $Title
}
Function StartHyper
{
  & 'C:\Users\flux\AppData\Local\Programs\Hyper\Hyper.exe'
}
Function ListExecutables
{
  Param ([String]$Path = ".")
  Get-ChildItem -Path "$Path" | Select-Object {$_.Name + "", "is an executable: " + $_.Name.EndsWith(".exe")}
}
Function StartAsAdmin
{
  <#
  .SYNOPSIS
    Start process as administrator.
  .DESCRIPTION
    Start process as administrator with an array of arguments. Uses Start-Process with -Verb RunAs.
  .PARAMETER Process
    The name or path of the process.
  .PARAMETER Arguments
    An array of arguments in the form of @('Arg_1', 'Arg_2', 'Arg_3', ...).
  .EXAMPLE
    StartAsAdmin -Process cmd -Arguments @('/k', 'TITLE List Desktop &', 'COLOR 1F &', 'ls', 'C:\Users\<USERNAME>\Desktop')
  .EXAMPLE
    StartAsAdmin $Env:COMSPEC @('/k', 'TITLE List Desktop &', 'COLOR 1F &', 'ls', 'C:\Users\<USERNAME>\Desktop')
  .NOTES
    FluxFuncs.psm1
    Author: Ian Pride 
    Modified date: 11:54 AM Saturday, January 21, 2023 CST
    Version 1.0.0 - Added Get-Help comments
  #>
  Param (
    [Parameter(Mandatory)][String]$Process,
    [Array]$Arguments = @{}
  )
  Start-Process "$Process" `
    -ArgumentList $Arguments `
    -Verb RunAs `
}
Function StartVim
{
  Param([String]$File)
  nvim "$File"
}
Function StartNVim
{
  Param([String]$File)
  nvim "$File"
}
Function WH
{
  Param(
    [String]$ForegroundColor = [System.Console]::ForegroundColor,
    [String]$BackgroundColor = [System.Console]::BackgroundColor,
    [String]$String = ""
  )
  Write-Host -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor  "$String"
}
Function GetFullPaths
{
  Param([String]$Path = ".\")
  If ($Path)
  {
    If (Test-Path $Path)
    {
      Return (Get-ChildItem $Path).FullName
    }
    Else
    {
      Return
    }
  }
  Return (Get-ChildItem).FullName
}
Function GetPath
{
  Return $PWD | Select-Object -ExpandProperty Path
}
Function GetPackages
{
  Return @(Get-AppPackage | ForEach-Object {$_.Name})
}
Function GetBoxDate
{
  $date_ = $(Get-Date)
  $box = @{
    'horizontal'=[char]0x2500
    'vertical'=[char]0x2502
    'upperleft'=[char]0x250C
    'upperright'=[char]0x2510
    'lowerleft'=[char]0x2514
    'lowerright'=[char]0x2518
  }
  for ($index = 0; $index -lt ($date_.Length + 2); $index++)
  {
    $line = "$line" + $box.horizontal
  }
  Write-Host(
    $box.upperleft  + $line   + $box.upperright + "`n" +
    $box.vertical   + " " + $date_  + " " + $box.vertical   + "`n" +
    $box.lowerleft  + $line   + $box.lowerright
  )
}
Function ProcKill
{
  Param([Array]$Procs)
  If ($Procs.LongLength -gt 0)
  {
    Get-Process -Name $Procs -ErrorAction SilentlyContinue |
      ForEach-Object {Stop-Process -Name $_.Name -Force -ErrorAction SilentlyContinue}
    Return 0
  }
  Return 1
}
Function SetCursor
{
  Param([Bool]$Mode = $true)
  [System.Console]::CursorVisible = $Mode
}
Function GetParent
{
  Param([Parameter(Mandatory=$true)][Object[]]$ProcessObject)
  If (($null -ne $ProcessObject) -and ($null -ne $ProcessObject.Parent)){
    Return $($ProcessObject.Parent)
  }
  Return $false
}
Function GetParents
{
  Param([Parameter(Mandatory=$true)][Object[]]$ProcessObject)
  If ($null -ne $ProcessObject)
  {
    $parents = @()
    while ($ProcessObject = $ProcessObject.Parent) { $parents += $ProcessObject }
    Return $parents
  }
  Return $false
}
Function ListConsoleProcess
{
  If ($PIDTHIS = Get-Process -Id $PID)
  {
    Write-Host("Current Process of [" + $PIDTHIS.ProcessName + "]")
    $PIDTHIS
    Write-Host("")
    If ($PIDPARENTS = GetParents -ProcessObject $PIDTHIS)
    {
      Write-Host("Parent Processes of [" + $PIDTHIS.ProcessName + "]")
      $PIDPARENTS
    }
  }
}
Function ShowPoshThemes
{
  Get-ChildItem -Name -Path 'C:\Users\flux\Documents\PowerShell\Modules\oh-my-posh\3.153.0\themes' -Filter *.omp.json -ErrorAction SilentlyContinue -OutVariable themes | Out-Null
  $index = 0
  foreach ($file in $themes)
  {
    $index++
    $theme = $file.Replace(".omp.json", "")
    Set-PoshPrompt -Theme $theme
    Write-Host "Current Theme: [$index] $theme"
    Read-Host -Prompt "Press [Enter] to continue or [Ctrl+C] to set theme.."
  }
}
Function GetPoshThemes
{
  Get-ChildItem -Name -Path 'C:\Users\flux\Documents\PowerShell\Modules\oh-my-posh\3.153.0\themes' -Filter *.omp.json -ErrorAction SilentlyContinue -OutVariable themes | Out-Null
  Return $themes
}
Function GetKeys
{
  do
  {
    # wait for a key to be available:
    If ([Console]::KeyAvailable)
    {
      # read the key, and consume it so it won't
      # be echoed to the console:
      $keyInfo = [Console]::ReadKey($true)
      # exit loop
      break
    }
    # write a dot and wait a second
    Write-Host '.' -NoNewline
    Start-Sleep -Seconds 1
  } while ($true)
  # emit a new line
  Write-Host
  # show the received key info object:
  $keyInfo
}
Function GetMCChunk
{
  Param
  (
    [Parameter(Mandatory=$true)][int]$X,
    [Parameter(Mandatory=$true)][int]$Z
  )
  while (($X % 16) -ne 0) {$X--}
  while (($Z % 16) -ne 0) {$Z--}
  Write-Host("From: " + $X + "," + $Z + " To: " + $($X + 15) + "," + $($Z + 15))
}
Function UnlockHosts
{
  & 'C:\Program Files (x86)\IObit\IObit Unlocker\IObitUnlocker.exe' /None /Advanced $Env:WINDIR\drivers\etc\hosts
}
Function RestartExplorer
{
  Write-Host "Restarting Explorer.`nAttempting to stop Explorer."
  $(Start-Process -Path 'C:\Windows\System32\taskkill.exe' -ArgumentList '/im Explorer.exe /f' -Verb RunAs -Wait -ErrorVariable Error) 2>&1 | Out-Null
  if ($Error.Count -eq 1)
  {
    $global:LASTEXITCODE = 254
    Write-Error($Error.Message)
    return
  }
  Write-Host "Attempting to start Explorer."
  $(Start-Process 'C:\Windows\Explorer.exe' -Wait -ErrorVariable Error) 2>&1 | Out-Null
  if ($Error.Count -eq 1)
  {
    $global:LASTEXITCODE = 255
    Write-Error($Error.Message)
    return
  }
  Write-Host "Explorer restarted successfully."
}
Function GetGHStats # Finish the C++ version of this
{
  Param(
    [Parameter(Mandatory=$true)][string]$UserName,
    [string]$BackgroundColor  = "1f1f1f",
    [string]$TextColor        = "F0F0F0",
    [string]$ShowIcons        = "true",
    [string]$Theme            = "dracula",
    [string]$BorderRadius     = "24",
    [string]$CustomTitle      = $UserName + "%27s+GitHub+Stats"
    )
  $url = @(
    'https://github-readme-stats.vercel.app/api'
    '?username='      + $UserName
    '&bg_color='      + $BackgroundColor
    '&text_color='    + $TextColor
    '&show_icons='    + $ShowIcons
    '&theme='         + $Theme
    '&border_radius=' + $BorderRadius
    '&custom_title='  + $CustomTitle) -Join ''
  Write-Host($url)
  # rundll32 url,OpenURL "$url"
}
Function GetProcHwnd
{
  Param ([Parameter(Mandatory)][String]$ProcName)
  $hwnd = (Get-Process -Name "$ProcName" -ErrorAction SilentlyContinue).MainWindowHandle |
    ForEach-Object {If ([int]$_ -gt 0) {$_}}
  If ($null -eq $hwnd) {Return 0} Else {Return $hwnd}
}
Function MCVote
{
  Param([Parameter(Mandatory)][String]$File)
  if ( -Not (Test-Path -Path "$File") )
  {
    $global:LASTEXITCODE = 1
    Write-Error "`"$File`" was not found."
    return
  }
  Get-Content -Path "$File" | ForEach-Object { rundll32.exe url,OpenURL "$_" }
}
Function HexToDec
{
  Param([Parameter(Mandatory)][String]$Hexadecimal)
  if ($Hexadecimal.SubString(0, 2) -ne '0x')
  {
    $Hexadecimal = '0x' + $Hexadecimal
  }
  [UInt32]"$Hexadecimal"
}
Function PrintBoxChars
{
  Write-Host(9473..9580 | ForEach-Object { "$(if ($_ -eq 9473) { ' ' })" + '{0:x}' -f $_ + ': ' + [char]$_ + "$(if (($_ % 8) -eq 0) { "`n"  })"  }) -NoNewline
}
Function GetFileSizesInDirectory
{
  Param([String]$Path = '.\', [String]$SizeType = "1KB", [Int]$Round = 2, [Bool]$Recurse = $false)
  if ($Recurse)
  {
    [Float]$value1 = "$([Math]::Round($(((Get-ChildItem -Path "$Path" -File -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -sum).Sum)/$SizeType), $Round))"
    [Float]$value2 = "$([Math]::Round($(((Get-ChildItem -Path "$Path" -File -Recurse -Hidden -ErrorAction SilentlyContinue | Measure-Object -Property Length -sum).Sum)/$SizeType), $Round))"
    [Float]$result = $([Float]$value1 + [Float]$value2)
  }
  else
  {
    [Float]$value1 = "$([Math]::Round($(((Get-ChildItem -Path "$Path" -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -sum).Sum)/$SizeType), $Round))"
    [Float]$value2 = "$([Math]::Round($(((Get-ChildItem -Path "$Path" -File -Hidden -ErrorAction SilentlyContinue | Measure-Object -Property Length -sum).Sum)/$SizeType), $Round))"
    [Float]$result = $([Float]$value1 + [Float]$value2)
  }
  Write-Output("$result" + $SizeType.SubString(1))
}
Function DecToHex()
{
  Param([Parameter(Mandatory)][Int64]$Decimal)
  '0x{0:X}' -f $Decimal
}
Function ListBrowserExtensions()
{
  return  @(  '.htm', '.html', '.pdf', '.shtml'
            , '.svg', '.webp', '.xht', '.xhtml'
            , 'FTP', 'HTTP', 'HTTPS', 'NEWS'
            , 'NNTP', 'SNEWS' ,'TEL', 'WEBCAL'
            , '.mhtml', 'htm', 'html', 'svg')
}
Function SetDefaultBrowser()
{
  Param([Parameter(Mandatory)][String]$Browser)
  ListBrowserExtensions | ForEach-Object {
    & 'C:\Users\flux\bin\SetUserFTA.exe' "$_" "$Browser" 
  }
}
Function GeneratePassword()
{
  Param([Int]$Length = 12)
  $charactersUpper = @(For ($index = 0; $index -lt 26; $index++) { [Char](65 + $index) })
  $singles = @($($charactersUpper | Get-Random))
  $charactersLower = @(For ($index = 0; $index -lt 26; $index++) { [Char](97 + $index) })
  $singles += $($charactersLower | Get-Random)
  $singlesSorted = @($($singles | Sort-Object { Get-Random }))
  $password = $singlesSorted[0]
  $passwordArray = @($singlesSorted[1])
  $characters = @(For ($index = 0; $index -lt 94; $index++) { [Char](33 + $index) })
  For ($index = 0; $index -lt ($Length - 2); $index++)
  {
    $passwordArray += $($characters | Get-Random)
  }
  $passwordArraySorted = @($($passwordArray | Sort-Object { Get-Random }))
  $password += $($passwordArraySorted -Join '')
  $password
  Set-Clipboard -Value "$password"
}
Function CNationMapCoords()
{
  <#
  .SYNOPSIS
    Open the map for the CNation Minecraft server in the default browser with some options. 
  .DESCRIPTION
    Open the map for the CNation Minecraft server in the default browser at coordinates with optional parameters for zoom level and realm selection (overworld, nether, and end).
  .PARAMETER X
    The X coordinate on the map. Defaults to 0.
  .PARAMETER Z
    The Z coordinate on the map. Defaults to 0.
  .PARAMETER Zoom
    The Zoom level of the map. Defaults to 5 (of 0-5).
  .PARAMETER Realm
    The realm of the map. Defauls to 'overworld' (of overworld, nether, or end).
  .EXAMPLE
    CNationMapCoords 2000 -1567
  .EXAMPLE
    CNationMapCoords -X 200 -Z -300 -Realm nether
  .NOTES
    FluxFuncs.psm1
    Author: Ian Pride 
    Modified date: Wed, 6:26 PM Sunday, January 1, 2023
    Version 1.0.0 - Added Get-Help comments
  #>
  Param([Int]$X = 0, [Int]$Z = 0, [UInt]$Zoom = 5, [String]$Realm = "overworld")
  if (-not ($Zoom -in 0..5))
  {
    $global:LASTEXITCODE = 255
    throw "`$Zoom [$Zoom] is not in the range of 0-5."
    return
  }
  if (-not ($Realm -in "overworld","nether","end"))
  {
    $global:LASTEXITCODE = 254
    throw "`$Realm [$Realm] is not in `"overworld`",`"nether`",`"end`"'"
    return
  }
  rundll32.exe url,OpenURL "https://map.cnation.net/?world=minecraft_$Realm&zoom=$Zoom&x=$X&z=$Z"
}
Function WTTR_CLI()
{
  <#
  .SYNOPSIS
    WTTR.IN command line wrapper function. 
  .DESCRIPTION
    WTTR.IN command line wrapper function with a few options. This function is incomplete and needs work for PNG's.
  .PARAMETER Location
    The location of the weather output. This is always the first option.
  .PARAMETER Format
    Any formatting of the weather output (?format=<FORMATTING>).
  .PARAMETER Language
    The language of the weather output (?lang=<LANGUAGE>).
  .PARAMETER Additional
    Any additional options of the weather output (?M, ?T, ?Etc.).
  .EXAMPLE
    WTTR_CLI -Location 'Decatur,Illinois' -Format '%t'
  .EXAMPLE
    WTTR_CLI 'Decatur,Illinois' -Format 1
  .EXAMPLE
    WTTR_CLI 'Decatur,Illinois' -Additional @('T', 'M')
  .NOTES
    FluxFuncs.psm1
    Author: Ian Pride 
    Modified date: 8:18 PM Monday, January 2, 2023
    Version 1.0.0 - Added Get-Help comments
  #>
  Param(
    [String]$Location = "",
    [String]$Format = "",
    [String]$Language = "",
    [Array]$Additional = @()
  )
  $url = "https://wttr.in/"
  $hasFirst = $false
  if ($Location.Length -gt 0)
  {
    $url += $Location
  }
  if ($Format.Length -ne "")
  {
    $url += "?format=$Format" 
    $hasFirst = $true
  }
  if ($Language.Length -gt 0)
  {
    if ($hasFirst)
    {
      $url += '&' 
    }
    else
    {
      $url += '?'
      $hasFirst = $true
    }
    $url += "lang=$Language" 
  }
  If ($Additional.Length -gt 0)
  {
    ForEach ($item in $Additional)
    {
      if ($hasFirst)
      {
        $url += '&' 
      }
      else
      {
        $url += '?'
        $hasFirst = $true
      }
      $url += $item  
    }
  }
  curl "$url"
}
Function Printpath()
{
  <#
  .SYNOPSIS
    Print the $Env:PATH variable.
  .DESCRIPTION
    Print the $Env:PATH variable split by the ';' delimeter.
  .EXAMPLE
    WTTR_CLI -Location 'Decatur,Illinois' -Format '%t'
  .EXAMPLE
    PrintPath
  .NOTES
    FluxFuncs.psm1
    Author: Ian Pride 
    Modified date: 12:26 PM Friday, January 20, 2023 CST
    Version 1.0.0 - Added Get-Help comments
  #>
  $(Write-Output $Env:PATH).Split(';')
}
Function DiffUnique()
{
  <#
  .SYNOPSIS
    Print differences in two files.
  .DESCRIPTION
    Print unique differences in two files with Compare-Object and Format-List.
  .PARAMETER FileA
    The path of the 1st file.
  .PARAMETER FileB
    The path of the 2nd file.
  .EXAMPLE
    DiffUnique -FileA .\filea.txt -FileB .\fileb.txt
  .EXAMPLE
    DiffUnique .\filea.txt .\fileb.txt
  .NOTES
    FluxFuncs.psm1
    Author: Ian Pride 
    Modified date: 1:37 PM Friday, January 20, 2023
    Version 1.0.0 - Added Get-Help comments
  #>
  Param([Parameter(Mandatory)][String]$FileA, [Parameter(Mandatory)][String]$FileB)
  if (-not (Test-Path $FileA -PathType Leaf))
  {
    $global:LASTEXITCODE = 255
    throw "`$FileA [$FileA] does not exist."
    return
  }
  if (-not (Test-Path $FileB -PathType Leaf))
  {
    $global:LASTEXITCODE = 254
    throw "`$FileB [$FileB] does not exist."
    return
  }
  Compare-Object (Get-Content "$FileA") (Get-Content "$FileB") | Format-List
}
Function CreateAutorun()
{
  Param(
    [String]$Path = '.',
    [String]$Open = '',
    [String]$Icon = '',
    [String]$Label = '',
    [Boolean]$Overwrite = $true
  )
  $Name = 'Autorun.inf'
  $File = "${Path}\${Name}"
  $File = $File.Replace("\\", "\")
  $content = "open=$Open`nicon=$Icon`nlabel=$Label"
  if (-not (Test-Path "${File}" -PathType Leaf 2>&1))
  {
    try
    {
      New-Item -Path "$Path" -Name "$Name" -ErrorVariable NewError -ErrorAction SilentlyContinue
      if ($NewError)
      {
        throw $NewError
      }
    }
    catch
    {
      $global:LASTEXITCODE = 255
      Write-Error $NewError.Exception
      Write-Error "$File cannot be created."
      return
    }
  }
  else
  {
    if ($Overwrite)
    {
      $content | Out-File -FilePath "$File"
    }
    return
  }
  $content | Out-File -FilePath "$File"
}
Function Pause()
{
  Param([String]$Prompt)
  Read-Host "$Prompt"
}
Function RemoveEmptyDirectories()
{
  <#
  .SYNOPSIS
    Remove empty directories.
  .DESCRIPTION
    Remove empty directories from a path. Recursive by default.
  .PARAMETER Path
    The working root path. Defaults to '.\'
  .PARAMETER Recurse
    Recurse into sub directories. $true by default.
  .EXAMPLE
    RemoveEmptyDirectories -Path 'C:\'
  .EXAMPLE
    RemoveEmptyDirectories -Recurse $false
  .NOTES
    FluxFuncs.psm1
    Author: Ian Pride 
    Modified date: 11:56 PM Saturday, February 4, 2023
    Version 1.0.0 - Added Get-Help comments
  #>
  Param([String]$Path = '.\', [Boolean]$Recurse = $true)
  if ($Recurse)
  {
    $directories = Get-ChildItem -Path "$Path" -Recurse -Directory
  }
  else
  {
    $directories = Get-ChildItem -Path "$Path" -Directory
  }
  $directories |
    ForEach-Object {
      if ( (Get-ChildItem $_.FullName | Measure-Object | Select-Object -ExpandProperty Count) -eq 0) {
              Remove-Item -Force -Recurse $_.FullName
      }
    }
}
Function Set-Shortcut()
{
  <#
  .SYNOPSIS
    Create a shortcut.
  .DESCRIPTION
    Create a shortcut from the PowerShell command line.
  .PARAMETER ShortcutDirectory
    The directory where the shortcut should be created.
  .PARAMETER ShortcutName
    The name of the shortcut (without the .lnk extension). 
  .PARAMETER TargetPath
    The path or name of the executable.
  .PARAMETER TargetParameters
    The parameters of the executable.
  .EXAMPLE
    PS> Set-Shortcut -ShortcutDirectory "$Env:USERPROFILE\Desktop" -ShortcutName 'Downloads' -TargetPath "$Env:WINDIR\explorer.exe" -TargetParameters 'shell:::{374DE290-123F-4565-9164-39C4925E467B}'
  .EXAMPLE
    PS> Set-Shortcut "$Env:USERPROFILE\Desktop" 'Downloads' "$Env:WINDIR\explorer.exe" 'shell:::{374DE290-123F-4565-9164-39C4925E467B}'
  .NOTES
    FluxFuncs.psm1
    Author: Ian Pride 
    Modified date: 11:34 AM Monday, March 13, 2023
    Version 1.0.0 - Added Get-Help comments
  #>
  Param
  (
    [String]$ShortcutDirectory = '.',
    [Parameter(Mandatory)][String]$ShortcutName,
    [Parameter(Mandatory)][String]$TargetPath,
    [String]$TargetParameters
  )
  shortcut /F:"$ShortcutDirectory\$ShortcutName.lnk" /A:Create /T:"$TargetPath" /P:"$TargetParameters"
}
# Function GodMode()
# {
#   <#
#   .SYNOPSIS
#     Create the God Mode directory. 
#   .DESCRIPTION
#     Create the God Mode folder in Windows.
#   .PARAMETER Path
#     The directory where the directory should be created. Defaults to '.\'.
#   .PARAMETER Name
#     The name of the directory. Defaults to 'GodMode'..
#   .EXAMPLE
#     GodMode
#   .EXAMPLE
#     GodMode -Path $Env:USERPROFILE\Desktop
#   .NOTES
#     FluxFuncs.psm1
#     Author: Ian Pride 
#     Modified date: 10:21 AM Wednesday, March 22, 2023 CST
#     Version 1.0.0 - Added Get-Help comments
#   #>
#   Param
#   (
#     [String]$Path = '.\',
#     [String]$Name = 'GodMode'
#   )
#   try
#   {
#     New-Item -Path "$Path" -Name "$Name.{ED7BA470-8E54-465E-825C-99712043E01C}" -ItemType Directory -ErrorVariable NewError -ErrorAction SilentlyContinue
#     if ($NewError)
#     {
#       throw $NewError
#     }
#   }
#   catch
#   {
#     $global:LASTEXITCODE = 255
#     Write-Error $NewError.Exception
#     Write-Error "$Path\$Name cannot be created."
#     return
#   }
# }
Function CreateRecycleBin()
{
  <#
  .SYNOPSIS
    Create the Recycle Bin directory. 
  .DESCRIPTION
    Create the Recycle Bin directory in Windows.
  .PARAMETER Path
    The directory where the directory should be created. Defaults to '.\'.
  .PARAMETER Name
    The name of the directory. Defaults to 'Recycle Bin'..
  .EXAMPLE
    CreateRecycleBin
  .EXAMPLE
    CreateRecycleBin -Path $Env:USERPROFILE\Desktop
  .NOTES
    FluxFuncs.psm1
    Author: Ian Pride 
    Modified date: 10:21 AM Wednesday, March 22, 2023 CST
    Version 1.0.0 - Added Get-Help comments
  #>
  Param
  (
    [String]$Path = '.\',
    [String]$Name = 'Recycle Bin'
  )
  try
  {
    New-Item -Path "$Path" -Name "$Name.{645FF040-5081-101B-9F08-00AA002F954E}" -ItemType Directory -ErrorVariable NewError -ErrorAction SilentlyContinue
    if ($NewError)
    {
      throw $NewError
    }
  }
  catch
  {
    $global:LASTEXITCODE = 255
    Write-Error $NewError.Exception
    Write-Error "$Path\$Name cannot be created."
    return
  }
}
Function Timer()
{
  Param
  (
    [Parameter(Mandatory)][Int64]$Value,
    [Switch]$Milliseconds,
    [Switch]$Seconds, [Switch]$Minutes,
    [Switch]$Hours, [Switch]$Days,
    [Switch]$Months, [Switch]$Years,
    [Switch]$Close
  )
  $exceedslimit = "$Value exceeds limit "
  if  ($Milliseconds)
  {
    if ($Value -gt 86400000)
    {
      $exceedslimit += "of 86400000."
      Write-Error $exceedslimit
      $global:LASTEXITCODE = 254
      return
    }
    $DueDate = (Get-Date).AddMilliseconds($Value)
  }
  elseif  ($Seconds)
  {
    if ($Value -gt 86400)
    {
      $exceedslimit += "of 86400."
      Write-Error $exceedslimit
      $global:LASTEXITCODE = 253
      return
    }
    $DueDate = (Get-Date).AddSeconds($Value)
  }
  elseif  ($Minutes)
  {
    if ($Value -gt 1440)
    {
      $exceedslimit += "of 1440."
      Write-Error $exceedslimit
      $global:LASTEXITCODE = 252
      return
    }
    $DueDate = (Get-Date).AddMinutes($Value)
  }
  elseif  ($Hours)
  {
    if ($Value -gt 24)
    {
      $exceedslimit += "of 24."
      Write-Error $exceedslimit
      $global:LASTEXITCODE = 251
      return
    }
    $DueDate = (Get-Date).AddHours($Value)
  }
  else
  {
    if ($Value -gt 86400)
    {
      $exceedslimit += "of 86400."
      Write-Error $exceedslimit
      $global:LASTEXITCODE = 253
      return
    }
    $DueDate = (Get-Date).AddSeconds($Value)
  }
  Add-Type -AssemblyName System.Windows.Forms
  Add-Type -AssemblyName System.Drawing
  $Form  = New-Object system.Windows.Forms.Form
  $Form.Width   = "140"
  $Form.Height  = "100"
  $lblCountDown = New-Object System.Windows.Forms.Label
  $lblCountDown.AutoSize = $true
  $lblCountDown.Font = "Century, 15"
  $lblCountDown.Text =    
    "{0:hh}:{0:mm}:{0:ss}:{0:fff}" -f 
    ($DueDate - (Get-Date))
  $Form.Controls.Add($lblCountDown)
  $tmrCountdown = New-Object System.Windows.Forms.Timer
  $tmrCountdown.Interval = 10
  $tmrCountdown.add_Tick(
    {
      $lblCountDown.Text = "{0:hh}:{0:mm}:{0:ss}:{0:fff}" -f ($DueDate - (Get-Date))
      if
      (
        ( [Int64]$lblCountDown.Text.SubString(0, 2) -eq 0) -and
        ( [Int64]$lblCountDown.Text.SubString(3, 2) -eq 0) -and
        ( [Int64]$lblCountDown.Text.SubString(6, 2) -eq 0) -and
        ( [Int64]$lblCountDown.Text.SubString(9) -lt 100)
      )
      {
        $tmrCountdown.enabled = $false
        $lblCountDown.Text = "00:00:00:000"
        $tmrCountdown.Dispose()
        # $tmrCountdown.Stop()
        if ($Close)
        {
          $Form.Dispose()
          $Form.Close()
        }
        $lblCountDown.Text += "`nComplete."
      }
    }
  )
  $tmrCountdown.Start()
  $Form.ShowDialog()
}
Set-Alias -Name convert -Value 'C:\Program Files\Adobe\Adobe Photoshop 2021\convert.exe' -Description 'Imagemagick provided by Photoshop'
Export-ModuleMember -Alias '*'
Export-ModuleMember -Function '*'