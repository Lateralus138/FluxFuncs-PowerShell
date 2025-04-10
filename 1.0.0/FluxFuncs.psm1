# ╔══════════════════════════════════════════════════════════════════════╗
# ║ FluxFuncs - Flux Apex's random powershell function and alias module. ║
# ║ © 2023 Ian Pride - New Pride Software/Services                       ║
# ╚══════════════════════════════════════════════════════════════════════╝ 
Function SetConsole {
  Param ([String]$Title = $(Get-Date))
  $Host.UI.RawUI.WindowTitle = $Title
}
Function StartHyper {
  & 'C:\Users\flux\AppData\Local\Programs\Hyper\Hyper.exe'
}
Function ListExecutables {
  Param ([String]$Path = ".")
  Get-ChildItem -Path "$Path" | Select-Object { $_.Name + "", "is an executable: " + $_.Name.EndsWith(".exe") }
}
Function StartAsAdmin {
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
Function StartVim {
  Param([String]$File)
  nvim "$File"
}
Function StartNVim {
  Param([String]$File)
  nvim "$File"
}
Function WH {
  Param(
    [String]$ForegroundColor = [System.Console]::ForegroundColor,
    [String]$BackgroundColor = [System.Console]::BackgroundColor,
    [String]$String = ""
  )
  Write-Host -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor  "$String"
}
Function GetFullPaths {
  Param([String]$Path = ".\")
  If ($Path) {
    If (Test-Path $Path) {
      Return (Get-ChildItem $Path).FullName
    }
    Else {
      Return
    }
  }
  Return (Get-ChildItem).FullName
}
Function GetPath {
  Return $PWD | Select-Object -ExpandProperty Path
}
Function GetPackages {
  Return @(Get-AppPackage | ForEach-Object { $_.Name })
}
# Function GetBoxDate {
#   $date_ = $(Get-Date)
#   $box = @{
#     'horizontal' = [char]0x2500
#     'vertical'   = [char]0x2502
#     'upperleft'  = [char]0x250C
#     'upperright' = [char]0x2510
#     'lowerleft'  = [char]0x2514
#     'lowerright' = [char]0x2518
#   }
#   for ($index = 0; $index -lt ($date_.ToString().Length + 1); $index++) {
#     $line = "$line" + $box.horizontal
#   }
#   Write-Host(
#     $box.upperleft + $line + $box.upperright + "`n" +
#     $box.vertical + " " + $date_ + " " + $box.vertical + "`n" +
#     $box.lowerleft + $line + $box.lowerright
#   )
# }
Function GetBoxDate {
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
  Param(
    [ArgumentCompletions('Single', 'Double', 'SingleDouble', 'DoubleSingle')][String]$Style = 'single',
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
  Write-Host(
    $box.upperleft + $line + $box.upperright + "`n" +
    $box.vertical + " " + $date_.ToString() + " " + $box.vertical + "`n" +
    $box.lowerleft + $line + $box.lowerright
  )
}
Function ProcKill {
  Param([Array]$Procs)
  If ($Procs.LongLength -gt 0) {
    Get-Process -Name $Procs -ErrorAction SilentlyContinue |
    ForEach-Object { Stop-Process -Name $_.Name -Force -ErrorAction SilentlyContinue }
    Return 0
  }
  Return 1
}
Function SetCursor {
  Param([Bool]$Mode = $true)
  [System.Console]::CursorVisible = $Mode
}
Function GetParent {
  Param([Parameter(Mandatory = $true)][Object[]]$ProcessObject)
  If (($null -ne $ProcessObject) -and ($null -ne $ProcessObject.Parent)) {
    Return $($ProcessObject.Parent)
  }
  Return $false
}
Function GetParents {
  Param([Parameter(Mandatory = $true)][Object[]]$ProcessObject)
  If ($null -ne $ProcessObject) {
    $parents = @()
    while ($ProcessObject = $ProcessObject.Parent) { $parents += $ProcessObject }
    Return $parents
  }
  Return $false
}
Function ListConsoleProcess {
  If ($PIDTHIS = Get-Process -Id $PID) {
    Write-Host("Current Process of [" + $PIDTHIS.ProcessName + "]")
    $PIDTHIS
    Write-Host("")
    If ($PIDPARENTS = GetParents -ProcessObject $PIDTHIS) {
      Write-Host("Parent Processes of [" + $PIDTHIS.ProcessName + "]")
      $PIDPARENTS
    }
  }
}
Function ShowPoshThemes {
  Get-ChildItem -Name -Path 'C:\Users\flux\Documents\PowerShell\Modules\oh-my-posh\3.153.0\themes' -Filter *.omp.json -ErrorAction SilentlyContinue -OutVariable themes | Out-Null
  $index = 0
  foreach ($file in $themes) {
    $index++
    $theme = $file.Replace(".omp.json", "")
    Set-PoshPrompt -Theme $theme
    Write-Host "Current Theme: [$index] $theme"
    Read-Host -Prompt "Press [Enter] to continue or [Ctrl+C] to set theme.."
  }
}
Function GetPoshThemes {
  Get-ChildItem -Name -Path 'C:\Users\flux\Documents\PowerShell\Modules\oh-my-posh\3.153.0\themes' -Filter *.omp.json -ErrorAction SilentlyContinue -OutVariable themes | Out-Null
  Return $themes
}
Function GetKeys {
  do {
    # wait for a key to be available:
    If ([Console]::KeyAvailable) {
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
Function GetMCChunk {
  Param
  (
    [Parameter(Mandatory = $true)][int]$X,
    [Parameter(Mandatory = $true)][int]$Z
  )
  while (($X % 16) -ne 0) { $X-- }
  while (($Z % 16) -ne 0) { $Z-- }
  Write-Host("From: " + $X + "," + $Z + " To: " + $($X + 15) + "," + $($Z + 15))
}
Function UnlockHosts {
  & 'C:\Program Files (x86)\IObit\IObit Unlocker\IObitUnlocker.exe' /None /Advanced $Env:WINDIR\drivers\etc\hosts
}
Function RestartExplorer {
  Write-Host "Restarting Explorer.`nAttempting to stop Explorer."
  $(Start-Process -Path 'C:\Windows\System32\taskkill.exe' -ArgumentList '/im Explorer.exe /f' -Verb RunAs -Wait -ErrorVariable Error) 2>&1 | Out-Null
  if ($error_.Count -eq 1) {
    $global:LASTEXITCODE = 254
    Write-Error($error_.Message)
    return
  }
  Write-Host "Attempting to start Explorer."
  $(Start-Process 'C:\Windows\Explorer.exe' -Wait -ErrorVariable Error) 2>&1 | Out-Null
  if ($error_.Count -eq 1) {
    $global:LASTEXITCODE = 255
    Write-Error($error_.Message)
    return
  }
  Write-Host "Explorer restarted successfully."
}
Function GetGHStats {
  # Finish the C++ version of this
  Param(
    [Parameter(Mandatory = $true)][string]$UserName,
    [string]$BackgroundColor = "1f1f1f",
    [string]$TextColor = "F0F0F0",
    [string]$ShowIcons = "true",
    [string]$Theme = "dracula",
    [string]$BorderRadius = "24",
    [string]$CustomTitle = $UserName + "%27s+GitHub+Stats"
  )
  $url = @(
    'https://github-readme-stats.vercel.app/api'
    '?username=' + $UserName
    '&bg_color=' + $BackgroundColor
    '&text_color=' + $TextColor
    '&show_icons=' + $ShowIcons
    '&theme=' + $Theme
    '&border_radius=' + $BorderRadius
    '&custom_title=' + $CustomTitle) -Join ''
  Write-Host($url)
  # rundll32 url,OpenURL "$url"
}
Function GetProcHwnd {
  Param ([Parameter(Mandatory)][String]$ProcName)
  $hwnd = (Get-Process -Name "$ProcName" -ErrorAction SilentlyContinue).MainWindowHandle |
  ForEach-Object { If ([int]$_ -gt 0) { $_ } }
  If ($null -eq $hwnd) { Return 0 } Else { Return $hwnd }
}
Function MCVote {
  Param([Parameter(Mandatory)][String]$File)
  if ( -Not (Test-Path -Path "$File") ) {
    $global:LASTEXITCODE = 1
    Write-Error "`"$File`" was not found."
    return
  }
  Get-Content -Path "$File" | ForEach-Object { rundll32.exe url, OpenURL "$_" }
}
# Function HexToDec {
#   Param([Parameter(Mandatory)][String]$Hexadecimal)
#   if ($Hexadecimal.SubString(0, 2) -ne '0x') {
#     $Hexadecimal = '0x' + $Hexadecimal
#   }
#   [UInt32]"$Hexadecimal"
# }
Function PrintBoxChars {
  Write-Host(9473..9580 | ForEach-Object { "$(if ($_ -eq 9473) { ' ' })" + '{0:x}' -f $_ + ': ' + [char]$_ + "$(if (($_ % 8) -eq 0) { "`n"  })" }) -NoNewline
}
Function GetFileSizesInDirectory {
  Param([String]$Path = '.\', [String]$SizeType = "1KB", [Int]$Round = 2, [Bool]$Recurse = $false)
  if ($Recurse) {
    [Float]$value1 = "$([Math]::Round($(((Get-ChildItem -Path "$Path" -File -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -sum).Sum)/$SizeType), $Round))"
    [Float]$value2 = "$([Math]::Round($(((Get-ChildItem -Path "$Path" -File -Recurse -Hidden -ErrorAction SilentlyContinue | Measure-Object -Property Length -sum).Sum)/$SizeType), $Round))"
    [Float]$result = $([Float]$value1 + [Float]$value2)
  }
  else {
    [Float]$value1 = "$([Math]::Round($(((Get-ChildItem -Path "$Path" -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -sum).Sum)/$SizeType), $Round))"
    [Float]$value2 = "$([Math]::Round($(((Get-ChildItem -Path "$Path" -File -Hidden -ErrorAction SilentlyContinue | Measure-Object -Property Length -sum).Sum)/$SizeType), $Round))"
    [Float]$result = $([Float]$value1 + [Float]$value2)
  }
  Write-Output("$result" + $SizeType.SubString(1))
}
Function DecToHex() {
  Param([Parameter(Mandatory)][Int64]$Decimal)
  '0x{0:X}' -f $Decimal
}
Function ListBrowserExtensions() {
  return  @(  '.htm', '.html', '.pdf', '.shtml'
    , '.svg', '.webp', '.xht', '.xhtml'
    , 'FTP', 'HTTP', 'HTTPS', 'NEWS'
    , 'NNTP', 'SNEWS' , 'TEL', 'WEBCAL'
    , '.mhtml', 'htm', 'html', 'svg')
}
Function SetDefaultBrowser() {
  Param([Parameter(Mandatory)][String]$Browser)
  ListBrowserExtensions | ForEach-Object {
    & 'C:\Users\flux\bin\SetUserFTA.exe' "$_" "$Browser" 
  }
}
Function GeneratePassword() {
  Param([Int]$Length = 12)
  $charactersUpper = @(For ($index = 0; $index -lt 26; $index++) { [Char](65 + $index) })
  $singles = @($($charactersUpper | Get-Random))
  $charactersLower = @(For ($index = 0; $index -lt 26; $index++) { [Char](97 + $index) })
  $singles += $($charactersLower | Get-Random)
  $singlesSorted = @($($singles | Sort-Object { Get-Random }))
  $password = $singlesSorted[0]
  $passwordArray = @($singlesSorted[1])
  $characters = @(For ($index = 0; $index -lt 94; $index++) { [Char](33 + $index) })
  For ($index = 0; $index -lt ($Length - 2); $index++) {
    $passwordArray += $($characters | Get-Random)
  }
  $passwordArraySorted = @($($passwordArray | Sort-Object { Get-Random }))
  $password += $($passwordArraySorted -Join '')
  $password
  Set-Clipboard -Value "$password"
}
Function CNationMapCoords() {
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
  if (-not ($Zoom -in 0..5)) {
    $global:LASTEXITCODE = 255
    throw "`$Zoom [$Zoom] is not in the range of 0-5."
    return
  }
  if (-not ($Realm -in "overworld", "nether", "end")) {
    $global:LASTEXITCODE = 254
    throw "`$Realm [$Realm] is not in `"overworld`",`"nether`",`"end`"'"
    return
  }
  rundll32.exe url, OpenURL "https://map.cnation.net/?world=minecraft_$Realm&zoom=$Zoom&x=$X&z=$Z"
}
Function WTTR_CLI() {
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
  if ($Location.Length -gt 0) {
    $url += $Location
  }
  if ($Format.Length -ne "") {
    $url += "?format=$Format" 
    $hasFirst = $true
  }
  if ($Language.Length -gt 0) {
    if ($hasFirst) {
      $url += '&' 
    }
    else {
      $url += '?'
      $hasFirst = $true
    }
    $url += "lang=$Language" 
  }
  If ($Additional.Length -gt 0) {
    ForEach ($item in $Additional) {
      if ($hasFirst) {
        $url += '&' 
      }
      else {
        $url += '?'
        $hasFirst = $true
      }
      $url += $item  
    }
  }
  curl "$url"
}
Function Printpath() {
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
Function DiffUnique() {
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
  if (-not (Test-Path $FileA -PathType Leaf)) {
    $global:LASTEXITCODE = 255
    throw "`$FileA [$FileA] does not exist."
    return
  }
  if (-not (Test-Path $FileB -PathType Leaf)) {
    $global:LASTEXITCODE = 254
    throw "`$FileB [$FileB] does not exist."
    return
  }
  Compare-Object (Get-Content "$FileA") (Get-Content "$FileB") | Format-List
}
Function CreateAutorun() {
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
Function Pause() {
  Param([String]$Prompt)
  Read-Host "$Prompt"
}
Function RemoveEmptyDirectories() {
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
  if ($Recurse) {
    $directories = Get-ChildItem -Path "$Path" -Recurse -Directory
  }
  else {
    $directories = Get-ChildItem -Path "$Path" -Directory
  }
  $directories |
  ForEach-Object {
    if ( (Get-ChildItem $_.FullName | Measure-Object | Select-Object -ExpandProperty Count) -eq 0) {
      Remove-Item -Force -Recurse $_.FullName
    }
  }
}
Function Set-Shortcut() {
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
Function CreateRecycleBin() {
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
  try {
    New-Item -Path "$Path" -Name "$Name.{645FF040-5081-101B-9F08-00AA002F954E}" -ItemType Directory -ErrorVariable NewError -ErrorAction SilentlyContinue
    if ($NewError) {
      throw $NewError
    }
  }
  catch {
    $global:LASTEXITCODE = 255
    Write-Error $NewError.Exception
    Write-Error "$Path\$Name cannot be created."
    return
  }
}
Function Timer() {
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
  if ($Milliseconds) {
    if ($Value -gt 86400000) {
      $exceedslimit += "of 86400000."
      Write-Error $exceedslimit
      $global:LASTEXITCODE = 254
      return
    }
    $DueDate = (Get-Date).AddMilliseconds($Value)
  }
  elseif ($Seconds) {
    if ($Value -gt 86400) {
      $exceedslimit += "of 86400."
      Write-Error $exceedslimit
      $global:LASTEXITCODE = 253
      return
    }
    $DueDate = (Get-Date).AddSeconds($Value)
  }
  elseif ($Minutes) {
    if ($Value -gt 1440) {
      $exceedslimit += "of 1440."
      Write-Error $exceedslimit
      $global:LASTEXITCODE = 252
      return
    }
    $DueDate = (Get-Date).AddMinutes($Value)
  }
  elseif ($Hours) {
    if ($Value -gt 24) {
      $exceedslimit += "of 24."
      Write-Error $exceedslimit
      $global:LASTEXITCODE = 251
      return
    }
    $DueDate = (Get-Date).AddHours($Value)
  }
  else {
    if ($Value -gt 86400) {
      $exceedslimit += "of 86400."
      Write-Error $exceedslimit
      $global:LASTEXITCODE = 253
      return
    }
    $DueDate = (Get-Date).AddSeconds($Value)
  }
  Add-Type -AssemblyName System.Windows.Forms
  Add-Type -AssemblyName System.Drawing
  $Form = New-Object system.Windows.Forms.Form
  $Form.Width = "140"
  $Form.Height = "100"
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
      ) {
        $tmrCountdown.enabled = $false
        $lblCountDown.Text = "00:00:00:000"
        $tmrCountdown.Dispose()
        # $tmrCountdown.Stop()
        if ($Close) {
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
Function RunSteamApp() {
  <#
  .SYNOPSIS
    Run a Steam app. 
  .DESCRIPTION
    Run a Steam app by id from Powershell.
  .PARAMETER Id
    The integer id of the steam app.
  .EXAMPLE
    RunSteamApp -Id 250420
  .NOTES
    FluxFuncs.psm1
    Author: Ian Pride 
    Modified date: 3:21 PM Sunday, April 30, 2023
    Version 1.0.0 - Added Get-Help comments
  #>
  Param([Parameter(Mandatory)][Int]$Id)
  explorer steam://rungameid/$Id
}
Function GetSteamGameList() {
  <#
  .SYNOPSIS
    Get a user's Steam game list. 
  .DESCRIPTION
    Provide a user name to get load a url in the default web browser to get a user's game list in form of XML.
  .PARAMETER User
    The Steam user name.
  .PARAMETER FileName
    Filename without the xml extension; downloads the file instead of displaying in the default web browser.
  .PARAMETER Path
    The path where <FileName> will be downloaded to. Only works when <FileName> is provided. Defaults to '.'.
  .EXAMPLE
    GetSteamGameList -User <USERNAME> -FileName 'steam_games' -Path $Env:USERPROFILE\Desktop
  .NOTES
    FluxFuncs.psm1
    Author: Ian Pride 
    Modified date: 10:21 AM Wednesday, March 22, 2023 CST
    Version 1.0.0 - Added Get-Help comments
  #>
  Param
  (
    [Parameter(Mandatory)][String]$User,
    [String]$FileName,
    [String]$Path = '.'  
  )
  if (-Not $FileName) {
    rundll32 url, OpenURL "https://steamcommunity.com/id/$User/games?xml=1"
    return
  }
  try {
    (Invoke-WebRequest "https://steamcommunity.com/id/$User/games?xml=1").Content |
    Out-File -FilePath "$Path\$FileName.xml" -ErrorVariable OutError
    if ($OutError) {
      throw $OutError
    }
  }
  catch {
    Write-Error $OutError.Message
    $global:LASTEXITCODE = 255
  }
}
Function LastModified() {
  <#
  .SYNOPSIS
    List files in a directory sorted by last modified.
  .DESCRIPTION
    List files in a directory sorted by last modified status in ascending order.
  .PARAMETER Path
    Path to sort.
  .EXAMPLE
    LastModified -Path C:\
  .NOTES
    FluxFuncs.psm1
    Author: Ian Pride 
    Modified date: 10:21 AM Wednesday, March 22, 2023 CST
    Version 1.0.0 - Added Get-Help comments
  #>
  Param([String]$Path = '.', $ExtraOptions)
  Get-ChildItem -Path "$Path" @ExtraOptions |
  Sort-Object -Property LastWriteTime |
  ForEach-Object { $_.FullName }
}
Function Get-MD5() {
  <#
  .SYNOPSIS
    Get the MD5 hash of a file.
  .DESCRIPTION
    Get the MD5 hash of a file.
  .PARAMETER File
    Path to the file to check.
  .EXAMPLE
    Get-MD5 -File 'C:\Path\to\program.exe'
  .NOTES
    FluxFuncs.psm1
    Author: Ian Pride 
    Modified date: 10:21 AM Wednesday, March 22, 2023 CST
    Version 1.0.0 - Added Get-Help comments
  #>
  Param([Parameter(Mandatory)][String]$File)
  if (-Not (Test-Path -Path "$File")) {
    Write-Error "$file not found."
    $global:LASTEXITCODE = 255
    return
  }
  Get-FileHash -Path "$file" -Algorithm MD5
}
Function TemperatureConvert() {
  <#
  .SYNOPSIS
    Temerature conversion.
  .DESCRIPTION
    Convert temperatures from Celsius to Fahrenheit and vice versa.
  .PARAMETER Temperature
    The temperature to convert.
  .PARAMETER Celsius
    Switch; value returned is in Celsuis. Default value.
  .PARAMETER Fahrenheit
    Switch; value returned is in Fahrenheit.
  .PARAMETER DecimalWidth
    Number of decimal width. Defaults to 2.
  .PARAMETER Symbol
    Switch; Return the value with the F or C symbol.
  .EXAMPLE
    PS> TemperatureConvert 0
    32
  .EXAMPLE
    PS> TemperatureConvert 100
    212
  .EXAMPLE
    PS> TemperatureConvert 80 -Celsius -DecimalWidth 6
    26.666666
  .EXAMPLE
    PS> TemperatureConvert 80 -Celsius -DecimalWidth 0
    27
  .EXAMPLE
    PS> TemperatureConvert 80 0 -Celsius -Symbol
    27C
  .EXAMPLE
    PS> TemperatureConvert 0 -Symbol -Fahrenheit
    32F
  .NOTES
    FluxFuncs.psm1
    Author: Ian Pride 
    Modified date: 02:25 , June 8, 2023 Universal Time Coordinated
    Version 1.0.0 - Added Get-Help comments
  #>
  Param
  (
    [Parameter(Mandatory)][Double]$Temperature,
    [Switch]$Celsius,
    [Switch]$Fahrenheit,
    [Int]$DecimalWidth = 2,
    [Switch]$Symbol = $false
  )
  $Symbol_ = ""
  If (($Celsius -eq $false) -And ($Fahrenheit -eq $false)) { $Celsius = $true; $Fahrenheit = $false }
  If ($Celsius -eq $true) { $Fahrenheit = $false; $Celsius = $true }
  If ($Fahrenheit -eq $true) { $Celsius = $false; $Fahrenheit = $true }
  If ($Symbol) {
    If ($Celsius -eq $true) { $Symbol_ = "C" }
    Else { $Symbol_ = "F" }
  }
  If ($Celsius -eq $true) { Write-Host("$([Math]::Round([Double](($Temperature - 32) * ( 5 / 9)), $DecimalWidth))" + "$Symbol_") }
  Else { Write-Host("$([Math]::Round([Double]((($Temperature * ( 9 / 5 )) + 32)), $DecimalWidth))" + "$Symbol_") }
}
Function Get-EmptyDirectory {
  <#
.SYNOPSIS
    Get empty directories using underlying Get-ChildItem cmdlet
 
.NOTES
    Name: Get-EmptyDirectory
    Author: theSysadminChannel
    Version: 1.0
    DateCreated: 2021-Oct-2
  
.LINK
     https://thesysadminchannel.com/find-empty-folders-powershell/ -
  
.EXAMPLE
    Get-EmptyDirectory -Path \\Server\Share\Folder -Depth 2 
#>
 
  [CmdletBinding()]
 
  param(
    [Parameter(
      Mandatory = $true,
      Position = 0
    )]
    [string]    $Path,
 
    [Parameter(
      Mandatory = $false,
      Position = 1
    )]
    [switch]    $Recurse,
 
    [Parameter(
      Mandatory = $false,
      Position = 2
    )]
    [ValidateRange(1, 15)]
    [int]    $Depth
  )
 
  BEGIN {}
 
  PROCESS {
    try {
      $ItemParams = @{
        Path      = $Path
        Directory = $true
      }
      if ($PSBoundParameters.ContainsKey('Recurse')) {
        $ItemParams.Add('Recurse', $true)
      }
 
      if ($PSBoundParameters.ContainsKey('Depth')) {
        $ItemParams.Add('Depth', $Depth)
      }
      $FolderList = Get-ChildItem @ItemParams | Select-Object -ExpandProperty FullName
 
      foreach ($Folder in $FolderList) {
        if (-not (Get-ChildItem -Path $Folder)) {
          [PSCustomObject]@{
            EmtpyDirectory = $true
            Path           = $Folder
          }
        }
        else {
          [PSCustomObject]@{
            EmtpyDirectory = $false
            Path           = $Folder
          }
        }
      }
    }
    catch {
      Write-Error $_.Exception.Message
    }
  }
 
  END {}
}
# Function IObitUnlocker
# {
#   <#
#   .SYNOPSIS
#     Full wrapper for IObitUnlocker.exe.
#   .DESCRIPTION
#     A wrapper function to make using IoBit Unlocker easier in PowerShell with error checking and path resolve.
#   .PARAMETER Normal
#     Attempt a normal unlock of the file only. This is the default mode.
#   .PARAMETER Advanced
#     Attempt a forced unlock of the file and related processes. Use this if Normal mode was not sucessful.
#   .PARAMETER Help
#     Open the help window.
#   .PARAMETER None
#     Unlock the file only.
#   .PARAMETER Delete
#     Unlock the file and delete it.
#   .PARAMETER Rename
#     Unlock the file and rename it.
#   .PARAMETER Move
#     Unlock the file and move it to a new directory.
#   .PARAMETER Copy
#     Unlock the file and copy it to a new directory.
#   .EXAMPLE
#     PS> IObitUnlocker -Help
#   .EXAMPLE
#     PS> IObitUnlocker -None '.\file_1.txt','.\file_2.exe'
#   .EXAMPLE
#     PS> IObitUnlocker -Advanced -Delete '.\file_1.txt','.\file_2.exe'
#   .EXAMPLE
#     PS> IObitUnlocker -Rename '.\file_1.txt','.\file_2.exe','.\file_1.txt.old','.\file_2.exe.old'
#   .EXAMPLE
#     PS> IObitUnlocker -Move '.\file_1.txt','.\file_2.exe','.\new_directory\'
#   .EXAMPLE
#     PS> IObitUnlocker -Copy '.\file_1.txt','.\file_2.exe','.\new_directory\'
#   .NOTES
#     FluxFuncs.psm1
#     Author: Ian Pride 
#     Modified date: 11:12 AM Monday, August 28, 2023
#     Version 1.0.0 - Added Get-Help comments
#   #>
#   Param(
#     [Switch]$Normal,
#     [Switch]$Advanced,
#     [Switch]$Help,
#     [String[]]$None,
#     [String[]]$Delete,
#     [String[]]$Rename,
#     [String[]]$Move,
#     [String[]]$Copy
#   )
#   $exe = 'C:\Program Files (x86)\IObit\IObit Unlocker\IObitUnlocker.exe'
#   $PathCommands = @()
#   if ($Help) { & $exe /?; return }
#   if ($Normal) { $PathCommands += '/Normal' }
#   if ($Advanced) { $PathCommands += '/Advanced' }
#   if ($None.Count -gt 0)
#   {
#     $PathCommands += '/None'
#     for ($index = 0; $index -lt $None.Count; ++$index)
#     {
#       try
#       {
#         $None[$index] = (Resolve-Path $None[$index] -ErrorAction SilentlyContinue -ErrorVariable NewError).Path
#         if ($NewError)
#         {
#           throw $NewError
#         }
#       }
#       catch
#       {
#         $global:LASTEXITCODE = 255
#         Write-Error $NewError.Exception
#         return
#       }
#       if ($index -eq 0)
#       {
#         $PathCommands += ('"' + $None[$index] + '"')
#       }
#       else
#       {
#         $PathCommands[$PathCommands.GetUpperBound(0)] = ($PathCommands[$PathCommands.GetUpperBound(0)] + ',"' + $None[$index] + '"')
#       }
#     }
#     & $exe @PathCommands
#     return
#   }
#   if ($Delete.Count -gt 0)
#   {
#     $PathCommands += '/Delete '
#     for ($index = 0; $index -lt $Delete.Count; ++$index)
#     {
#       try
#       {
#         $Delete[$index] = (Resolve-Path $Delete[$index] -ErrorAction SilentlyContinue -ErrorVariable NewError).Path
#         if ($NewError)
#         {
#           throw $NewError
#         }
#       }
#       catch
#       {
#         $global:LASTEXITCODE = 254
#         Write-Error $NewError.Exception
#         return
#       }
#       if ($index -eq 0)
#       {
#         $PathCommands += ('"' + $Delete[$index] + '"')
#       }
#       else
#       {
#         $PathCommands[$PathCommands.GetUpperBound(0)] = $PathCommands[$PathCommands.GetUpperBound(0)] + ',"' + $Delete[$index] + '"'
#       }
#     }
#     & $exe @PathCommands
#     return
#   }
#   if ($Rename.Count -gt 0)
#   {
#     if (($Rename.Count % 2) -ne 0)
#     {
#       $global:LASTEXITCODE = 253
#       Write-Error "Array count for 'Rename' is uneven."
#       return
#     }
#     $renameMax = ($Rename.Count / 2)
#     $PathCommands += '/Rename'
#     for ($index = 0; $index -lt $Rename.Count; ++$index)
#     {
#       if ($index -lt $renameMax)
#       {
#         try
#         {
#           $Rename[$index] = (Resolve-Path $Rename[$index] -ErrorAction SilentlyContinue -ErrorVariable NewError).Path
#           if ($NewError)
#           {
#             throw $NewError
#           }
#         }
#         catch
#         {
#           $global:LASTEXITCODE = 252
#           Write-Error $NewError.Exception
#           return
#         }
#       }
#       if ($index -lt $renameMax)
#       {
#         if ($index -eq 0)
#         {
#           $PathCommands += ('"' + $Rename[$index] + '"')
#         }
#         else
#         {
#           $PathCommands[$PathCommands.GetUpperBound(0)] = ($PathCommands[$PathCommands.GetUpperBound(0)] + ',"' + $Rename[$index] + '"')
#         }
#       }
#       else
#       {
#         if ($index -eq $renameMax)
#         {
#           $PathCommands += ($Rename[$index])
#         }
#         else
#         {
#           $PathCommands[$PathCommands.GetUpperBound(0)] = ($PathCommands[$PathCommands.GetUpperBound(0)] + ',' + $Rename[$index])
#         }
#       }
#     }
#     & $exe @PathCommands
#     return
#   }
#   if ($Move.Count -gt 0)
#   {
#     if ($Move.Count -lt 2)
#     {
#       $global:LASTEXITCODE = 251
#       Write-Error "Array count for 'Move' is less than 2."
#       return
#     }
#     $PathCommands += '/Move'
#     for ($index = 0; $index -lt ($Move.Count - 1); ++$index)
#     {
#       try
#       {
#         $Move[$index] = (Resolve-Path $Move[$index] -ErrorAction SilentlyContinue -ErrorVariable NewError).Path
#         if ($NewError)
#         {
#           throw $NewError
#         }
#       }
#       catch
#       {
#         $global:LASTEXITCODE = 250
#         Write-Error $NewError.Exception
#         return
#       }
#       if ($index -eq 0)
#       {
#         $PathCommands += ('"' + $Move[$index] + '"')
#       }
#       else
#       {
#         $PathCommands[$PathCommands.GetUpperBound(0)] = ($PathCommands[$PathCommands.GetUpperBound(0)] + ',"' + $Move[$index] + '"')
#       }
#     }
#     try
#     {
#       $Move[$Move.GetUpperBound(0)] = (Resolve-Path $Move[$Move.GetUpperBound(0)] -ErrorAction SilentlyContinue -ErrorVariable NewError).Path
#       if ($NewError)
#       {
#         throw $NewError
#       }
#     }
#     catch
#     {
#       $global:LASTEXITCODE = 249
#       Write-Error $NewError.Exception
#       return
#     } 
#     $PathCommands += $Move[$Move.GetUpperBound(0)]
#     & $exe @PathCommands
#     return
#   }
#   if ($Copy.Count -gt 0)
#   {
#     if ($Copy.Count -lt 2)
#     {
#       $global:LASTEXITCODE = 248
#       Write-Error "Array count for 'Copy' is less than 2."
#       return
#     }
#     $PathCommands += '/Copy'
#     for ($index = 0; $index -lt ($Copy.Count - 1); ++$index)
#     {
#       try
#       {
#         $Copy[$index] = (Resolve-Path $Copy[$index] -ErrorAction SilentlyContinue -ErrorVariable NewError).Path
#         if ($NewError)
#         {
#           throw $NewError
#         }
#       }
#       catch
#       {
#         $global:LASTEXITCODE = 247
#         Write-Error $NewError.Exception
#         return
#       }
#       if ($index -eq 0)
#       {
#         $PathCommands += ('"' + $Copy[$index] + '"')
#       }
#       else
#       {
#         $PathCommands[$PathCommands.GetUpperBound(0)] = ($PathCommands[$PathCommands.GetUpperBound(0)] + ',"' + $Copy[$index] + '"')
#       }
#     }
#     try
#     {
#       $Copy[$Copy.GetUpperBound(0)] = (Resolve-Path $Copy[$Copy.GetUpperBound(0)] -ErrorAction SilentlyContinue -ErrorVariable NewError).Path
#       if ($NewError)
#       {
#         throw $NewError
#       }
#     }
#     catch
#     {
#       $global:LASTEXITCODE = 246
#       Write-Error $NewError.Exception
#       return
#     }
#     $PathCommands += $Copy[$Copy.GetUpperBound(0)]
#     & $exe @PathCommands
#     return
#   }
#   & $exe
# }
Function Power()
{
  <#
  .SYNOPSIS
    Math Power function.
  .DESCRIPTION
    The PowerShell math power function formatted that works with any decimal value and returns a decimal value.
  .PARAMETER Number
    Any decimal value.
  .PARAMETER Power
    Any integer value.
  .EXAMPLE
    PS> Pow -Number 3 -Power 3
    27
  .EXAMPLE
    PS> Pow 3 3
    27
  .NOTES
    FluxFuncs.psm1
    Author: Ian Pride 
    Modified date: 03:04 , October 26, 2023 Universal Time Coordinated
    Version 1.0.0 - Added Get-Help comments
  #>
  Param(
    [Parameter(Mandatory)][Decimal]$Number,
    [Parameter(Mandatory)][Int]$Power
  )
  $Answer = 1
  while ($Power -gt 0) {
    $lastBit = ($Power -band 1)
    if ($lastBit) {
      $Answer = ($Answer * $Number)
    }
    $Number = $Number * $Number
    $Power = ($Power -shr 1)
  }
  return $Answer
}
Function Get-HostsCompressionScriptsDownloadCount()
{
  $members = @('.[0].assets[0].download_count', '.[0].assets[1].download_count', '.[1].assets[0].download_count', '.[1].assets[1].download_count', '.[2].assets[0].download_count');
  $dl_values = @(curl -s -L 'https://api.github.com/repos/Lateralus138/hosts-compression-scripts/releases' | jq -r ($members -join ',').ToString());
  ($dl_values | Measure-Object -Sum).Sum
}
Function Lock-File()
{
  <#
    .SYNOPSIS
    Lock a file.
    .DESCRIPTION
    Lock a file using [System.IO.File]::Open() and pausing to wait for user input.
    .PARAMETER File
    The path to the file.
    .PARAMETER Message
    The message to print while waiting.
    .INPUTS
    None.
    .OUTPUTS
    None.
    .EXAMPLE
    PS> LockFile -File '.\file.txt'
  #>
  Param(
    [Parameter(Mandatory)][String]$File,
    [String]$Message = 'Press any key to continue... ')
  if (-Not (Test-Path -Path "$File"))
  {
    Write-Error "$File not found."
    $global:LASTEXITCODE = 255
    return
  }
  $file_ = [System.IO.File]::Open($File, 'Open', 'Read', 'None')
  $Message
  $null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
  $file_.Close()
}
# Function IsPrime()
# {
#   <#
#     .SYNOPSIS
#     Lock a file.
#     .DESCRIPTION
#     Lock a file using [System.IO.File]::Open() and pausing to wait for user input.
#     .PARAMETER File
#     The path to the file.
#     .PARAMETER Message
#     The message to print while waiting.
#     .INPUTS
#     None.
#     .OUTPUTS
#     None.
#     .EXAMPLE
#     PS> LockFile -File '.\file.txt'
#   #>
#   Param([Parameter(Mandatory)][Double]$Number)
#   $Number -split '(?=\d)' | ForEach-Object { $sum += $_ }
#   if (($Number -lt 2) -or ((($Number -band 1) -ne 1) -and (-not 2)) -or (($sum % 3) -eq 0)) { return $false }

# }
Function Test-Prime
{
  <#
    .SYNOPSIS
    Test if a number is a prime.
    .DESCRIPTION
    Test if any number is a prime number.
    .PARAMETER Number
    Any integer or float value.
    .INPUTS
    None.
    .OUTPUTS
    None.
    .EXAMPLE
    PS> Test-Prime 29
  #>
  param([Parameter(ValueFromPipeline=$true, Mandatory=$true)][Double]$Number)
  Process
  {
    $Prime = $true;
    if ($Number -lt 2) { $Prime = $false; }
    if ($Number -gt 3)
    {
      $Sqrt = [math]::Sqrt($Number); 
      for($index = 2; $index -le $Sqrt; $index++)
      {
        if ($Number % $index -eq 0)
        {
          $Prime = $false;
          break;
        }
      }
    }
    return $Prime;
  }
}
Function Get-Fibonacci()
{
  <#
    .SYNOPSIS
    Get Fibonacci numbers.
    .DESCRIPTION
    Get a Fibonacci number by it's index.
    .PARAMETER Number
    Any integer value.
    .INPUTS
    None.
    .OUTPUTS
    None.
    .EXAMPLE
    PS> Get-Fibonacci 10
    .EXAMPLE
    PS> (1..10).Foreach({ Get-Fibonacci $_ })
  #>
  param([Parameter(ValueFromPipeline=$true, Mandatory=$true)][Int]$Number)
  if ($Number -lt 2) { return $Number }
  else { return (Get-Fibonacci ($Number - 1)) + (Get-Fibonacci ($Number - 2)) }
}
Function Get-Factors()
{
  <#
    .SYNOPSIS
    Get all factors of a number.
    .DESCRIPTION
    Get all multiplier factors of a number.
    .PARAMETER Number
    Any integer value.
    .INPUTS
    None.
    .OUTPUTS
    None.
    .EXAMPLE
    PS> Get-Factors 10
    .EXAMPLE
    PS> Get-Factors -Number 52
  #>
  param
  (
    [Parameter(ValueFromPipeline=$true, Mandatory=$true)][Int]$Number,
    [Parameter(ValueFromPipeline=$true, Mandatory=$false)][String]$Delim = ", "
  )
  for ($i = 1; $i -le [Math]::Floor([Math]::Sqrt($Number)); $i++)
  {
    if (($Number % $i) -eq 0)
    {
      [String]$i + $Delim + [String]($Number / $i)
    }
  }
}
Function Get-CreationNationMaps()
{
  <#
    .SYNOPSIS
    Get maps for the Creation Nation server.
    .DESCRIPTION
    Get all or a single 512x512 map[s] from the Creation Nation Minecraft server.
    .PARAMETER X
    The X quadrant from -30 to 29; defaults to 0.
    .PARAMETER Y
    The Y quadrant from -30 to 29; defaults to 0.
    .PARAMETER All
    Get all maps. Negates X and Y.
    .PARAMETER Quality
    Quality of image from 1 to 3; defaults to 3.
    .PARAMETER OutDirectory
    The path to output image files; defaults to '.\'.
    .PARAMETER IndexFileNames
    Rename files to and integer index instead of the default x and y values. E.g: 0.png, 1.png, 2.png, etc... 
    .INPUTS
    None.
    .OUTPUTS
    None.
    .EXAMPLE
    PS> Get-CreationNationMaps -X -30 -Y 10
    .EXAMPLE
    PS> Get-CreationNationMaps -All
  #>
  param(
    [Int16]$X = 0,
    [Int16]$Y = 0,
    [Switch]$All,
    [Int16]$Quality = 3,
    [String]$OutDirectory = '.\',
    [Switch]$IndexFileNames
  )
  if (-Not ($X -In -30..29))
  {
    Write-Error "X: [$X] is not in range of -30 to 29."
    $global:LASTEXITCODE = 255
    return   
  }
  if (-Not ($Y -In -30..29))
  {
    Write-Error "Y: [$Y] is not in range of -30 to 29."
    $global:LASTEXITCODE = 254
    return 
  }
  if (-Not ($Quality -In 1..3))
  {
    Write-Error "Quality: [$Quality] is not in range of 1 to 3."
    $global:LASTEXITCODE = 253
    return 
  }
  if (-Not (Test-Path -Path $OutDirectory))
  {
    Write-Error "OutDirectory: [$OutDirectory] does not exist."
    $global:LASTEXITCODE = 252
    return 
  }
  if (-Not (Test-Path -Path $OutDirectory -PathType Container))
  {
    Write-Error "OutDirectory: [$OutDirectory] exists, but is not a directory."
    $global:LASTEXITCODE = 251
    return 
  }
  if ($IndexFileNames)
  {
    $Index = 1
  }
  if (-Not $All)
  {
    $OriginalFileName = [String]$X + "_" + $Y + ".png"
    $FileName = if (-Not ($IndexFileNames)) { $OriginalFileName } else { [String]$Index + ".png" }
    $OutFile = $OutDirectory + "\" + $FileName
    $FullUrl = [String]"http://play.cnation.net:25182/tiles/minecraft_overworld/" + $Quality + "/" + $OriginalFileName
    Invoke-WebRequest -Uri $FullUrl -OutFile  $OutFile
  }
  else
  {
    for ($YIndex = -30; $YIndex -le 29; $YIndex++)
    {
      for ($XIndex = -30; $XIndex -le 29; $XIndex++)
      {
        $OriginalFileName = [String]$XIndex + "_" + $YIndex + ".png"
        $FileName = if (-Not ($IndexFileNames)) { $OriginalFileName } else { [String]$Index + ".png" }
        $OutFile = $OutDirectory + "\" + $FileName
        $FullUrl = [String]"http://play.cnation.net:25182/tiles/minecraft_overworld/" + $Quality + "/" + $OriginalFileName
        Invoke-WebRequest -Uri $FullUrl -OutFile  $OutFile
        $Index++
        Write-Progress  -Activity ("Downloading file: [" + $FileName + "]...") `
                        -PercentComplete (($Index / 3600) * 100) -Status 'Downloading Creation Nation maps...'
      }
    };
  }
}
Function Build-CreationNationMap()
{
  <#
    .SYNOPSIS
    Build map for the Creation Nation server.
    .DESCRIPTION
    Build the full Creation Nation map from pre-exisiting indexed maps in a directory retrieved by Get-CreationNationMaps.
    .PARAMETER ImagePath
    Path of partial map image files; defaults to '.\'.
    .PARAMETER OutDirectory
    Output file directory; defaults to '.\'.
    .PARAMETER OutFileName
    Output file name; defaults to creation_nation_map.
    .PARAMETER XBegin
    Index start of horizontal range; defaults to 1.
    .PARAMETER YBegin
    Index start of vertical range; defaults to 1.
    .PARAMETER Width
    Width of horizontal range; defaults to 60.
    .PARAMETER Height
    Height of vertical range; defaults to 60.
    .INPUTS
    None.
    .OUTPUTS
    None.
    .EXAMPLE
    PS> Build-CreationNationMap
    .EXAMPLE
    PS> Build-CreationNationMaps -OutDirectory '.\cnation'
  #>
  param(
    [String]$ImagePath = '.\',
    [String]$OutDirectory = $ImagePath,
    [String]$OutFileName = 'creation_nation_map',
    [Int16]$XBegin = 1,
    [Int16]$YBegin = 1,
    [Int16]$Width,
    [Int16]$Height 
  )
  if (-Not (Test-Path -Path $ImagePath))
  {
    Write-Error "Path: [$ImagePath] does not exist."
    $global:LASTEXITCODE = 255
    return 
  }
  if (-Not (Test-Path -Path $ImagePath -PathType Container))
  {
    Write-Error "Path: [$ImagePath] exists, but is not a directory."
    $global:LASTEXITCODE = 254
    return 
  }

  $Width = if (-Not ($Width)) { (60 - ($XBegin - 1)) } else { $Width }
  $Height = if (-Not ($Height)) { (60 - ($YBegin - 1)) } else { $Height }
  if ($Width -gt 60)
  {
    Write-Error "Width: [$Width] is out of range."
    $global:LASTEXITCODE = 253
    return
  }
  if ($Height -gt 60)
  {
    Write-Error "Height: [$Height] is out of range."
    $global:LASTEXITCODE = 252
    return 
  }
  if (-Not ($XBegin -In 1..60))
  {
    Write-Error "XBegin: [$XBegin] is not in range of 1 to 60."
    $global:LASTEXITCODE = 251
    return
  }
  if (-Not ($YBegin -In 1..60))
  {
    Write-Error "YBegin: [$YBegin] is not in range of 1 to 60."
    $global:LASTEXITCODE = 250
    return
  }
  if (-Not ($OutFileName))
  {
    Write-Error "Output file name: [$OutFileName] is empty."
    $global:LASTEXITCODE = 241
    return  
  }
  [System.Collections.ArrayList]$map_images = @()
  for ($index = $YBegin; $index -lt ($YBegin + $Height); $index++)
  {
    $begin = ($XBegin + (60 * ($index - 1)))
    $end = (($XBegin + (60 * ($index - 1))) + ($Width - 1))
    [System.Collections.ArrayList]$temp_images = @(((($begin..$end) -join '.png ') + '.png').Split(' '))
    [System.Collections.ArrayList]$temp_images2 = @()
    $temp_images | ForEach-Object { [Void]$temp_images2.Add([String]"$ImagePath" + $_) }
    [Void]$map_images.Add($temp_images2)
    Remove-Variable temp_images
    Remove-Variable temp_images2
  }
  [System.Collections.ArrayList]$horz_images = @()
  for ($index = 1; $index -le $Height; $index++)
  {
    $horz = [String]$ImagePath + $index + "_horz.png"
    [Void]$horz_images.Add($horz)
    & 'C:\Program Files\Adobe\Adobe Photoshop 2021\convert.exe' +append $map_images[($index - 1)] $horz
    if ($LASTEXITCODE -ne 0)
    {
      Write-Error 'Could not build map.'
      $global:LASTEXITCODE = 240
      return 
    }
    Write-Progress  -Activity "Building Creation Nation horizontal map: " `
                    -PercentComplete $('{0:F2}' -f [Math]::Round( ($index / $Height) * 100, 2)) `
                    -Status " $index of $Height [$('{0:F2}%' -f [Math]::Round( ($index / $Height) * 100, 2))] completed: $horz... "
  }
  Write-Progress -Completed
  $out = $OutDirectory + $OutFileName + ".png"
  "Building Creation Nation full map as $out"
  & 'C:\Program Files\Adobe\Adobe Photoshop 2021\convert.exe' -append $horz_images $out
  if ($LASTEXITCODE -ne 0)
  {
    Write-Error 'Could not build map.'
    $global:LASTEXITCODE = 239
    return 
  }
  Remove-Item -Path "$ImagePath*_horz.png" -Force
}
Function Get-CreationNationShop()
{
  <#
    .SYNOPSIS
    
    .DESCRIPTION

    .PARAMETER

    .INPUTS

    .OUTPUTS

    .EXAMPLE
  #>
}
Function HexToRGB()
{
  <#
    .SYNOPSIS
    Convert hexadecimal color to RGB.
    .DESCRIPTION
    Convert hexadecimal colors to RGB values in an associative array (Red, Green, and Blue).
    .PARAMETER Hexadecimal
    The hexadecimal value to convert in hexadecimal or decimal format.
    .INPUTS
    None.
    .OUTPUTS
    None.
    .EXAMPLE
    PS> HexToRGB -Hexadecimal 0x7FFF7F

    Name                           Value
    ----                           -----
    Red                            127
    Green                          255
    Blue                           127

    .EXAMPLE
    PS> $RGB = HexToRGB -Hexadecimal 0x7FFF7F
    PS> $RGB.Red
    127
 
  #>
  param([Parameter(Mandatory)][Int]$Hexadecimal)
  if ($Hexadecimal -gt 0xffffff)
  {
    $global:LASTEXITCODE = 255
    Write-Error("Hexacimal: " + '0x{0:X}' -f $Hexadecimal + " ($Hexadecimal) exceeds the maximum " + '0x{0:X}' -f 0xFFFFFF + " (" + 0xFFFFFF + ").")
    return
  }
  return @{
    'Red'=$($Hexadecimal -shr 0x10);
    'Green'=$($Hexadecimal -shr 0x8 -band 0xff);
    'Blue'=$($Hexadecimal -shr 0x0 -band 0xff)
  }
}
Function ListBits
{
  Param([Int]$Bit, [Switch]$Total)
  if ($Total) { [Math]::Pow(2, $Bit - 1) * 2; return }
  if ($Bit -gt 0) { [Math]::Pow(2, $Bit - 1); ListBits -Bit (--$Bit) }
}
Function BitsInInt
{
  Param([Int128]$Number, [Int]$MaxBits = 64)
  1..$MaxBits | ForEach-Object {
    if ([Int128][Math]::Pow(2, $_) -gt $Number) {
      $_
      break
    }
  }
}
Function ConvertInt
{
  Param([Int64]$Number, [String]$To = 'binary')
  switch ( $To )
  {
    'binary' { [Int]$conversion = 2 }
    'bin' { [Int]$conversion = 2 }
    'decimal' { [Int]$conversion = 10 }
    'dec' { [Int]$conversion = 10 }
    'hexadecimal' { [Int]$conversion = 16 }
    'hex' { [Int]$conversion = 16 }
    default { [Int]$conversion = 2 }
  }
  [Convert]::ToString([Int64]$Number, [Int]$conversion)
}
Function ConvertIntToBinary
{
  Param([Int64]$Int)
  $(for ($i = 31; $i -ge 0; $i--) {
    $k = $Int -shr $i; if ($k -band 1) { 1 } else { 0 }
  }) -join '' -replace '^[0]+'
}
Function StringToBinary
{
  Param([String]$String)
  ($String.ToCharArray() | ForEach-Object { ConvertInt $([Int64][Byte][Char]$_) }) -join ' '
}
Function StringToBinaryShift
{
  Param([String]$String)
  $String.ToCharArray().ForEach( { ConvertIntToBinary -Int $([Byte][Char]"$_") } ) -join ' '
}
Function RGBBlock()
{
  <#
    .SYNOPSIS
    Preview RGB colors.
    .DESCRIPTION
    Prview RGB colors in the format of a color box using ANSI escape sequences.
    .PARAMETER Red
    Integer value of red in the range of 0-255.
    .PARAMETER Green
    Integer value of green in the range of 0-255.
    .PARAMETER Blue
    Integer value of blue in the range of 0-255.
    .PARAMETER width
    Width (character length) of the displayed box.
    .PARAMETER Hexadecimal
    Use a hexadecial value in place of RGB values.
    .INPUTS
    None
    .OUTPUTS
     System.String. RGBBlock outputs a string displaying RGB color.
    .EXAMPLE
    RGBBlock -Red 255 -Green 127 -Blue 191
    .EXAMPLE
    RGBBlock 255 127 191
    .EXAMPLE
    RGBBlock -Hexadecimal 0xff7fbf
  #>
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory = $false, Position = 0)][Int]$Red,
    [Parameter(Mandatory = $false, Position = 1)][Int]$Green,
    [Parameter(Mandatory = $false, Position = 2)][Int]$Blue,
    [Parameter(Mandatory = $false, Position = 3)][Int]$Width = 4,
    [Parameter(Mandatory = $false, Position = 4)][AllowNull()][System.Nullable[Int]]$Hexadecimal
  )
  $error_ = 0
  $Red,$Green,$Blue | ForEach-Object {
    $index++
    if (-Not ($_ -in 0..255)) {
      $error_ = $index
      Write-Error "[${_}] is not in the range of 0-255."
      $global:LASTEXITCODE = $error_
    }
  }
  if ($error_ -gt 0) { return }
  $stringMain = "`e[48;2;"
  if ($null -eq $Hexadecimal) {
    $stringMain += "${Red};${Green};${Blue}m"
  } else {
    $stringMain +=  "$(($Hexadecimal -shr 0x10) -band 0xff);$(($Hexadecimal -shr 0x8) -band 0xff);$(($Hexadecimal -shr 0x0) -band 0xff)m"
  }
  $stringMain += ' ' * $Width + "`e[0m"
  $stringMain
}
Function WebSafePreview()
{
  <#
    .SYNOPSIS
    Preview web safe colors.
    .DESCRIPTION
    Preview web safe colors using RGBBlock and websafe.exe.
    .PARAMETER Width
    Width of the each line. Defaults to 36
    .PARAMETER BlockWidth
    Width of the each color block. defaults to 4.
    .INPUTS
    None
    .OUTPUTS
     System.String. WebSafePreview outputs a string displaying web safe colors.
    .EXAMPLE
    WebSafePreview 
  #>
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory = $false, Position = 0)][Int]$Width = 36,
    [Parameter(Mandatory = $false, Position = 1)][Int]$BlockWidth = 4
  )
  $index = 0
  websafecolors 0x |
    ForEach-Object {
      $index++
      Write-Host -NoNewline "$(RGBBlock -Hexadecimal $_ -Width $BlockWidth)"
      if (($index % $Width) -eq 0) {''}
    }
}
Function CNationPlayers()
{
  <#
    .SYNOPSIS
    Get Creation Nation players.
    .DESCRIPTION
    Use jq to parse Creation Nation players.json.
    .PARAMETER Players
    Get specific players. Defaults to all players.
    .INPUTS
    None
    .OUTPUTS
     System.Array:Object[]. CNationPlayers outputs an array of strings of player names.
    .EXAMPLE
    CNationPlayers -Players @('User1', 'User2')
  #>
  Param([Array]$Players)
  $users = (Invoke-WebRequest -Uri 'https://map.cnation.net/tiles/players.json').Content | jq -r '.players.[].name'
  if ($Players.Count -gt 0) { $users = $users | Select-String $Players }
  return $users
}
Function ColorDiff()
{
  <#
    .SYNOPSIS
    RGB color difference.
    .DESCRIPTION
    Distance between 2 hexadcimal RGB colors.
    .PARAMETER ColorA
    First color.
    .PARAMETER ColorA
    Second color.
    .INPUTS
    None
    .OUTPUTS
     System.ValueType:Double. ColorDiff outputs a double float value.
    .EXAMPLE
    PS> ColorDiff -ColorA 0x9EDAE5 -ColorB 0x9AC8D2
    26.4764045897475
  #>
  Param([Int]$ColorA, [Int]$ColorB)
  $ra = HexToRGB $ColorA
  $rb = HexToRGB $ColorB
  $diffr = [Math]::Pow(($ra.Red - $rb.Red), 2)
  $diffg = [Math]::Pow(($ra.Green - $rb.Green), 2)
  $diffb = [Math]::Pow(($ra.Blue - $rb.Blue), 2)
  return [Math]::Sqrt($diffr + $diffg + $diffb)
}
Function PlayingCards()
{
  Param(
    [Switch]$Hearts,
    [Switch]$Diamonds,
    [Switch]$Spades,
    [Switch]$Clubs,
    [Switch]$Jokers
  )
  <#
    .SYNOPSIS
    Playing cards in a Powershell terminal.
    .DESCRIPTION
    Playing cards for use in a Powershell terminal.
    .PARAMETER Hearts
    Switch to return heart suit in the array. If no main suit switches are passed then all default to $true.
    .PARAMETER Diamonds
    Switch to return diamonds suit in the array. If no main suit switches are passed then all default to $true.
    .PARAMETER Spades
    Switch to return spades suit in the array. If no main suit switches are passed then all default to $true.
    .PARAMETER Clubs
    Switch to return clubs suit in the array. If no main suit switches are passed then all default to $true.
    .PARAMETER Jokers
    Switch to return jokers in the array. Defaults to false.
    .INPUTS
    None.
    .OUTPUTS
    System.Array:Object[]. PlayingCards returns an array.
    .EXAMPLE
    PS> (PlayingCards -Joker) -join ' '
    A♡   2♡   3♡   4♡   5♡   6♡   7♡   8♡   9♡   10♡   J♡   Q♡   K♡   A♢   2♢   3♢   4♢   5♢   6♢   7♢   8♢   9♢   10♢   J♢   Q♢   K♢   A♤   2♤   3♤   4♤   5♤   6♤   7♤   8♤   9♤   10♤   J♤   Q♤   K♤   A♧   2♧   3♧   4♧   5♧   6♧   7♧   8♧   9♧   10♧   J♧   Q♧   K♧   🃏 🃏
    .EXAMPLE
    PS> (PlayingCards -Hearts) -join ' '
    A♡   2♡   3♡   4♡   5♡   6♡   7♡   8♡   9♡   10♡   J♡   Q♡   K♡
  #>
  $cards = @()
  if ((-not ($Hearts)) -and (-not ($Diamonds)) -and (-not ($Spades)) -and (-not ($Clubs))) {
    $Hearts = $Diamonds = $Spades = $Clubs = $true
  }
  $cardValues = @('A'; 2..10; 'J'; 'Q'; 'K')
  if ($Hearts) {
    $cardValues | ForEach-Object {
      $cards += @($([String]$_ +  [Char]9825 + '  '))
    }
  }
  if ($Diamonds) {
    $cardValues | ForEach-Object {
      $cards += @($([String]$_ +  [Char]9826 + '  '))
    }
  }
  if ($Spades) {
    $cardValues | ForEach-Object {
      $cards += @($([String]$_ +  [Char]9828 + '  '))
    }
  }
  if ($Clubs) {
    $cardValues | ForEach-Object {
      $cards += @($([String]$_ +  [Char]9831 + '  '))
    }
  }
  if ($Jokers) {
    1..2 | ForEach-Object {
      $cards += @('J' + $([Char]::ConvertFromUtf32(0x1f0cf)))
    }
  }
  return $cards
}
Function FillEmptyDirectories()
{
  <#
    .SYNOPSIS
    Fill empty dirctories with a placeholder file.
    .DESCRIPTION
    Fill empty dirctories with a placeholder file. Defaults to .nomedia.
    .PARAMETER Path
    The parent path to search.
    .PARAMETER Name
    The name of the place holder file. Defaults to .nomedia
    .PARAMETER Recurse
    Search parent directory recursively.
    .INPUTS 
    None
    .OUTPUTS
    System.ValueType:Boolean. Returns true on successful completion and false if the Path was not found or a parameter was empty.
    .EXAMPLE
    PS> FillEmptyDirectories -Path ..\ -Recurse
  #>
  Param(
    [String]$Path = '.\',
    [String]$Name = '.nomedia',
    [Switch]$Recurse
  )
  if (-not (Test-Path -Path $Path))
  {
    Write-Error "${Path} does not exist."
    $global:LASTEXITCODE = 255
    return $false
  }
  if (-not (Test-Path -Path $Path -PathType Container))
  {
    Write-Error "${Path} is not a directory."
    $global:LASTEXITCODE = 254
    return $false
  }
  if (-not $Name)
  {
    Write-Error "File name is empty."
    $global:LASTEXITCODE = 253
    return $false
  }
  if (-not (Test-Path -Path ${PATH}\*))
  {
    New-Item -Path $Path -Name $Name -ItemType File -ErrorVariable niError
    if ($niError)
    {
      Write-Error "Could not create ${Name} in ${Path}."
      $global:LASTEXITCODE = 252
    }
  }
  $error_ = 252
  if ($Recurse)
  {
    Get-ChildItem -Path $Path -Recurse |
      Where-Object { $_.PSIsContainer } |
        ForEach-Object {
          $error_--
          $p = $_.FullName
          if (-not (Test-Path -Path "${p}\*"))
          {
            New-Item -Path $p -Name $Name -ItemType File -ErrorVariable niError
            if ($niError)
            {
              Write-Error "Could not create ${Name} in ${p}."
              $global:LASTEXITCODE = $error_
            }
          }
        }
  }
  return $true
}
Function DecToBin()
{
  <#
  .SYNOPSIS
  Convert decimals to binary.
  .DESCRIPTION
  Convert decimals to binary with a padding option.
  .PARAMETER Decimal
  Integer number to convert to binary.
  .PARAMETER Padding
  Prepend padding zeros if the output is not a specific length. Defaults to 0 for no padding.
  .INPUTS
  System.ValueType:Int32
    Accepts piped values of Int32.
  .OUTPUTS
  System.Object:String
  .EXAMPLE
  DecToBin -Decimal 20
  10100
  .EXAMPLE
  DecToBin -Decimal 20 -Padding 8
  00010100
  .EXAMPLE
  8,9,16,17,32,33 | DecToBin
  1000
  1001
  10000
  10001
  100000
  100001
  .EXAMPLE
  8,9,16,17,32,33 | DecToBin -Padding 8
  00001000
  00001001
  00010000
  00010001
  00100000
  00100001
  #>
  Param(
    [Parameter(Mandatory = $false, Position = 0)][Int]$Decimal,
    [Parameter(Mandatory = $false, Position = 1)][Int]$Padding = 0,
    [Parameter(Mandatory = $false, Position = 2, ValueFromPipeline)][Int]$PipedDecimal
  )
  begin
  { 
    $BinaryLambda = {
      Param([Int]$Value, [Int]$Pad = 0)
      while ($Value -gt 0) {
        $binary += @( if (($Value % 2) -lt 1) {0} else {1})
        $Value = [Math]::Floor($Value / 2)
      }
      if (($Pad -gt 0) -and ($binary.Count -lt $Pad)) { 1..($Pad - $binary.Count) | ForEach-Object { $binary += @(0) } }
      [Array]::Reverse($binary)
      $binary -join ''
    }  
    if ($Decimal) { &$BinaryLambda -Value $Decimal -Pad $Padding }
  }
  process { if ($PipedDecimal) { &$BinaryLambda -Value $PipedDecimal -Pad $Padding } }
}
Function IsPowerOf2()
{
  <#
  .SYNOPSIS
  Check if a value is a power of 2.
  .DESCRIPTION
  Return a boolean if a value is a power of 2.
  .PARAMETER Value
  Integer value to test.
  .INPUTS
  System.ValueType:Int32
  Accepts piped values of Int32.
  .OUTPUTS
  System.ValueType:Boolean
  .EXAMPLE
  PS> IsPowerOf2 -Value 16
  True
  .EXAMPLE
  PS> 0..8 | IsPowerOf2
  True    # 0
  True    # 1
  True    # 2
  False   # 3
  True    # 4
  False   # 5
  False   # 6
  False   # 7
  True    # 8
  #>
  Param(
    [Parameter(Mandatory = $false, Position = 0)][Int]$Value,
    [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline)][Int]$PipedValue
  )
  begin
  {
    $IsPowerOf2 = {
      Param([Int]$Value)
      if ( ($Value -band ($Value - 1)) -eq 0 ) { $true } else { $false }
    }
    if ($Value) { &$IsPowerOf2 -Value $Value }
  }
  process
  {
    if ($PipedValue) { &$IsPowerOf2 -Value $PipedValue }
  }
}
Function MCBBase()
{
  <#
  .SYNOPSIS
  Get the number of blocks needed for the basse of a Minecraft beacon.
  .DESCRIPTION
  Get the number of single/stacks of blocks/ingots of resources needed to make the pyramid base of Minecraft beacon.
  .PARAMETER Width
  Width number of each horizontal layer. Defaults to 1 [1-6].
  .PARAMETER Depth
  Depth number of each horizontal layer. Defaults to 1 [1-6].
  .PARAMETER Height
  Number of layers vertically. Defaults to 4 [1-4].
  .PARAMETER Ingots
  Return value is in ingots. Defaults to blocks.
  .PARAMETER Stacks
  Return value is in stacks. Defaults to singles.
  .EXAMPLE
  PS> MCBBase
  164
  .EXAMPLE
  PS> MCBBase -Width 2 -Depth 3
  244
  .EXAMPLE
  PS> MCBBase 2 3 -Stacks
  3.8125
  .EXAMPLE
  PS> MCBBase 2 3 -Ingots
  2196
  .EXAMPLE
  PS> MCBBase 2 3 -Ingots -Stacks
  34.3125
  #>
  Param(
    [Parameter(Mandatory = $false, Position = 0)][Int]$Width = 1,
    [Parameter(Mandatory = $false, Position = 1)][Int]$Depth = 1,
    [Parameter(Mandatory = $false, Position = 2)][Int]$Height = 4,
    [Parameter(Mandatory = $false, Position = 3)][Switch]$Ingots,
    [Parameter(Mandatory = $false, Position = 4)][Switch]$Stacks
  )
  begin
  {
    if (-not (($Width * $Depth) -in 1..6)) {
      Write-Error "Width: $Width x Depth: $Depth is not in the range of 1-6.";
      $global:LASTEXITCODE = 255;
      return
    }
    if (-not ($Height -in 1..6)) {
      Write-Error "Height: $Height is not in the range of 1-6.";
      $global:LASTEXITCODE = 254;
      return
    }
    switch ($Ingots) { $true { $ingot = 9 }; default { $ingot = 1 } }
    switch ($Stacks) { $true { $stack = 64 }; default { $stack = 1 } }
  }
  process
  {
    $sum = 0
    1..$Height | ForEach-Object {
      $sum += ($Width + ($_ * 2)) * ($Depth + ($_ * 2))
    }
  }
  end { return (($sum * $ingot) / $stack) }
}
# Function New-ModuleProject() {
#   <#
#     .SYNOPSIS
#     Create directories for a new PowerShell module.
#     .DESCRIPTION
#     Create directories for a new PowerShell module with various options.
#     .PARAMETER Path
#     Root of the project. Defaults to '.\'.
#     .PARAMETER Name
#     Name of the directory of the project.
#     .PARAMETER Version
#     Version number of the project. Defaults to 1.0.0.
#     .PARAMETER Loader
#     Name of the loader file; defaults to module.psm1
#     .PARAMETER PublicFunctions
#     Array of function file name to initialize in the public namespace.
#     .PARAMETER PrivateFunctions
#     Array of function file name to initialize in the private namespace.
#     .EXAMPLE
#     PS> New-ModuleProject -Name MyNewModule
#   #>
#   Param(
#     [Parameter(Position = 0)][String]$ProjectPath = '.\',
#     [Parameter(Position = 1, Mandatory = $true)][String]$Name,
#     [Parameter(Position = 2)][String]$Version = '1.0.0',
#     [Parameter(Position = 3)][String]$Loader = 'module',
#     [Parameter(Position = 4)][Array]$PublicFunctions = @(),
#     [Parameter(Position = 5)][Array]$PrivateFunctions = @()
#   )
#   $StringTest = {
#     Param([String]$String, [Int]$Err)
#     $status = $true
#     if (($String.Length -eq 0) -or ($String -match '^[\s|\t]+$') -or ($String -match '^[\s|\t].*$')) {
#       $global:LASTEXITCODE = $Err
#       Write-Error "$String is an invalid file name."
#       Write-Error "$String cannot be empty, start with a space and/or tabs, or contain only spaces and/or tabs."
#       $status = $false 
#     }
#     return $status
#   }
#   $errIndex = 255
#   if (-not (&$StringTest $Name $errIndex)) {
#     return
#   }
#   $errIndex--
#   if (-not (&$StringTest $Loader $errIndex)) {
#     return
#   }
#   $PathTestAndCreate = {
#     Param([String]$Path_, [Int]$Err, [String]$Type = 'Directory')
#     $status = $true
#     if ($Type -eq 'Directory') {
#       $t = 'Container'
#     }
#     if ($Type -eq 'File') {
#       $t = 'Leaf'
#     }
#     if (-Not (Test-Path "${Path_}" -PathType $t 2>&1)) {
#       try {
#         New-Item -Path "$Path_" -ItemType $Type -ErrorVariable NewError -ErrorAction SilentlyContinue
#         if ($NewError) {
#           throw $NewError
#         }
#       }
#       catch {
#         $global:LASTEXITCODE = $Err
#         Write-Error $NewError.Exception
#         Write-Error "$Path_ cannot be created."
#         $status = $false
#       }
#     }
#     return $status
#   }
#   $errIndex--
#   if (-not (&$PathTestAndCreate "$ProjectPath" $errIndex)) {
#     return
#   }
#   $errIndex--
#   if (-not (&$PathTestAndCreate "${ProjectPath}\${Name}" $errIndex)) {
#     return
#   }
#   $errIndex--
#   if (-not (&$PathTestAndCreate "${ProjectPath}\${Name}\${Version}" $errIndex)) {
#     return
#   }
#   $VERSIONPATH = "${ProjectPath}\${Name}\${Version}"
#   $directories = @("${VERSIONPATH}\private"; "${VERSIONPATH}\public"; "${VERSIONPATH}\tests")
#   $directories | ForEach-Object {
#     $errIndex--
#     if (-not (&$PathTestAndCreate "$_" $errIndex)) {
#       return
#     }   
#   }
#   $errIndex--
#   if (-not (&$PathTestAndCreate "${VERSIONPATH}\${Name}.psd1" $errIndex 'File')) {
#     return
#   }
#   $errIndex--
#   if (-not (&$PathTestAndCreate "${VERSIONPATH}\${Loader}.psm1" $errIndex 'File')) {
#     return
#   }
#   'Get-ChildItem -Path $PSScriptRoot\private, $PSScriptRoot\public -Filter *.ps1 | ForEach-Object { . $_ }' + "`n" + 'Get-ChildItem -Path $PSScriptRoot\public\*.ps1 | ForEach-Object { Export-ModuleMember -Function $_.Basename }' > "${VERSIONPATH}\${Loader}.psm1"
#   $errIndex--
#   $PublicFunctions | ForEach-Object {
#     $errIndex--
#     if (-not (&$PathTestAndCreate "${VERSIONPATH}\public\${_}.ps1" $errIndex 'File')) {
#        return
#     }  
#   }
#   $PrivateFunctions | ForEach-Object {
#     $errIndex--
#     if (-not (&$PathTestAndCreate "${VERSIONPATH}\private\${_}.ps1" $errIndex 'File')) {
#        return
#     }  
#   }
# }
Function Get-CmdSizeConversion() {
  <#
    .SYNOPSIS
    Convert CMD width and height to it's hexadecimal counterpart and vice versa.
    .DESCRIPTION
    Convert CMD width and height to it's hexadecimal High and Low bit counterpart and vice versa.
    .PARAMETER Width
    Integer width (columns).
    .PARAMETER Height
    Integer height (rows).
    .PARAMETER Prefix
    Prefix hexadecimal result with whatever the user likes.
    .PARAMETER Hex
    Convert to width and heighth from hexadecimal.
    .EXAMPLE
    PS> Get-CmdSizeConversion 197 102
    003300C5
    .EXAMPLE
    PS> Get-CmdSizeConversion 197 102 '0x'
    0x003300C5
    .EXAMPLE
    PS> Get-CmdSizeConversion -Hex 0x003300C5
    197
    102  
  #>
  Param([Int]$Width, [Int]$Height, [ArgumentCompletions('0x', '#')][String]$Prefix = '', [Int]$Hex)
  $widthHeightErrorFunc = {
    Param([Boolean]$Test, [String]$Message, [Int]$Value)
    $errObj = @{}
    switch ($Test) {
      False { $errObj.Value = $Value; $errObj.Message = 'Width' }
      default { $errObj.Value = ($Value - 1); $errObj.Message = 'Height' }
    }
    $Env:LASTEXITCODE = $errObj.Value
    Write-Error($errObj.Message + $Message)
  }
  switch ($PSBoundParameters.ContainsKey('Hex')) {
    True { return @( ($Hex -band 0xffff); (($Hex -shr 0xf) -band 0xffff) ) }
    default {
      if ($PSBoundParameters.ContainsKey('Width') -and $PSBoundParameters.ContainsKey('Height')) {
        if (($Width -ge 0) -and ($Height -ge 0)) { return "$Prefix{0:X8}" -f (($Height -shl 0xf) -bor $Width) }
        else {
          Invoke-Command $widthHeightErrorFunc -ArgumentList @(($Width -ge 0); ' is less than 0.'; 253)
          return
        }
      } else {
        Invoke-Command $widthHeightErrorFunc -ArgumentList  @($PSBoundParameters.ContainsKey('Width'); ' was not provided.'; 255)
        return
      }
    }
  } 
}
$drmemory_args = @{
  Name        = 'drmemory';
  Value       = 'C:\Program Files (x86)\Dr. Memory\bin64\drmemory.exe';
  Description = 'Dr. Memory - memory leak detector.'
}
$convert_args = @{
  Name        = 'convert';
  Value       = 'C:\Program Files\Adobe\Adobe Photoshop 2021\convert.exe';
  Description = 'Imagemagick provided by Photoshop.'
}
$xmlnotepad_args = @{
  Name        = 'xmlnotepad';
  Value       = 'C:\Program Files\WindowsApps\43906ChrisLovett.XmlNotepad_2.9.0.0_neutral__hndwmj480pefj\Application\XmlNotepad.exe';
  Description = 'Alias to XML Notepad.'
}
$vscodium1_args = @{
  Name        = 'vscodium';
  Value       = 'C:\Users\flux\bin\vscodium.cmd';
  Description = 'Alias to VS Codium.'
}
$vscodium2_args = @{
  Name        = 'code';
  Value       = 'C:\Users\flux\bin\vscodium.cmd';
  Description = 'Alias to VS Codium.'
}
$vscodium3_args = @{
  Name        = 'codium';
  Value       = 'C:\Users\flux\bin\vscodium.cmd';
  Description = 'Alias to VS Codium.'
}
$jq_args = @{
  Name        = 'jq';
  Value       = 'C:\Users\flux\AppData\Local\Microsoft\WinGet\Packages\jqlang.jq_Microsoft.Winget.Source_8wekyb3d8bbwe\jq-win64.exe';
  Description = 'Alias to jq-win64.exe.'
}
$hcsdls_args = @{
  Name        = 'hcsdls';
  Value       = 'Get-HostsCompressionScriptsDownloadCount';
  Description = 'Get my current download count from hosts-compression-scripts.'
}
$bingq_args = @{
  Name        = 'bq';
  Value       = 'C:\Users\flux\Documents\AutoHotkey\Programs\Bing Queries\bingqueries.exe';
  Description = 'Bing search automation.'
}
$jq_args = @{
  Name        = 'jq';
  Value       = 'C:\Users\flux\AppData\Local\Microsoft\WinGet\Packages\jqlang.jq_Microsoft.Winget.Source_8wekyb3d8bbwe\jq.exe';
  Description = 'Parse JSON with JQ (JSON Query)'
}
$minicap_args = @{
  Name        = 'minicap';
  Value       = 'C:\Program Files (x86)\MiniCap\MiniCap.exe';
  Description = 'Run MiniCap'
}
Set-Alias @minicap_args
Set-Alias @jq_args
# $unlocker_args = @{
#   Name        = 'iobitunlocker';
#   Value       = 'C:\Program Files (x86)\IObit\IObit Unlocker\IObitUnlocker.exe';
#   Description = 'Alias to IObitUnlocker.exe.'
# }
Set-Alias @bingq_args
Set-Alias @vscodium1_args
Set-Alias @vscodium2_args
Set-Alias @vscodium3_args
Set-Alias @drmemory_args
Set-Alias @convert_args
Set-Alias @xmlnotepad_args
Set-Alias @jq_args
Set-Alias @hcsdls_args
# Set-Alias @unlocker_args
Remove-Variable bingq_args
Remove-Variable vscodium1_args
Remove-Variable vscodium2_args
Remove-Variable vscodium3_args
Remove-Variable drmemory_args
Remove-Variable convert_args
Remove-Variable xmlnotepad_args
Remove-Variable jq_args
Remove-Variable hcsdls_args
Remove-Variable minicap_args
# Remove-Variable unlocker_args
Export-ModuleMember -Alias '*'
Export-ModuleMember -Function '*'