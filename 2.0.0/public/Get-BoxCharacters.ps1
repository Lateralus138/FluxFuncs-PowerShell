Function Get-BoxCharacters {
  <#
  .SYNOPSIS
  List all box characters.
  .DESCRIPTION
  List all Unicode box characters with a few options.
  .PARAMETER Minimum
  The minimum value. Defaults to 9473 (0x2501).
  .PARAMETER Maximum
  The maximum value. Defaults to 9580 (0x256c).
  .PARAMETER Value
  Display the the result with is integer hexadecimal value.
  .PARAMETER ValueFormat
  Use hexadecimal preformat value (0x or #). Defaults to nothing.
  .EXAMPLE
  PS> Get-BoxCharacters
  ━
  │
  ┃
  ┄
  ┅
  ┆
  ┇
  ┈
  ...
  .EXAMPLE
  PS> (Get-BoxCharatcers) -join ''
  ━│┃┄┅┆┇┈┉┊┋┌┍┎┏┐┑┒┓└┕┖┗┘┙┚┛├┝┞┟┠┡┢┣┤┥┦┧┨┩┪┫┬┭┮┯┰┱┲┳┴┵┶┷┸┹┺┻┼┽┾┿╀╁╂╃╄╅╆╇╈╉╊╋╌╍╎╏═║╒╓╔╕╖╗╘╙╚╛╜╝╞╟╠╡╢╣╤╥╦╧╨╩╪╫╬
  .EXAMPLE
  PS> Get-BoxCharacters -Value
  2501: ━
  2502: │
  2503: ┃
  2504: ┄
  2505: ┅
  2506: ┆
  2507: ┇
  2508: ┈
  .EXAMPLE
  PS> Get-BoxCharacters -Value -ValueFormat 0x
  0x2501: ━
  0x2502: │
  0x2503: ┃
  0x2504: ┄
  0x2505: ┅
  0x2506: ┆
  0x2507: ┇
  0x2508: ┈
  .EXAMPLE
  PS> Write-Host $($index =0; Get-BoxCharacters -Value -ValueFormat 0x | ForEach-Object { $_ -join ""; switch ((++$index % 8) -eq 0) { $true { "`b`n" }; default { '' } } }) -NoNewline
  0x2501: ━  0x2502: │  0x2503: ┃  0x2504: ┄  0x2505: ┅  0x2506: ┆  0x2507: ┇  0x2508: ┈ 
  0x2509: ┉  0x250a: ┊  0x250b: ┋  0x250c: ┌  0x250d: ┍  0x250e: ┎  0x250f: ┏  0x2510: ┐
  0x2511: ┑  0x2512: ┒  0x2513: ┓  0x2514: └  0x2515: ┕  0x2516: ┖  0x2517: ┗  0x2518: ┘
  0x2519: ┙  0x251a: ┚  0x251b: ┛  0x251c: ├  0x251d: ┝  0x251e: ┞  0x251f: ┟  0x2520: ┠
  0x2521: ┡  0x2522: ┢  0x2523: ┣  0x2524: ┤  0x2525: ┥  0x2526: ┦  0x2527: ┧  0x2528: ┨
  0x2529: ┩  0x252a: ┪  0x252b: ┫  0x252c: ┬  0x252d: ┭  0x252e: ┮  0x252f: ┯  0x2530: ┰
  0x2531: ┱  0x2532: ┲  0x2533: ┳  0x2534: ┴  0x2535: ┵  0x2536: ┶  0x2537: ┷  0x2538: ┸
  0x2539: ┹  0x253a: ┺  0x253b: ┻  0x253c: ┼  0x253d: ┽  0x253e: ┾  0x253f: ┿  0x2540: ╀
  0x2541: ╁  0x2542: ╂  0x2543: ╃  0x2544: ╄  0x2545: ╅  0x2546: ╆  0x2547: ╇  0x2548: ╈
  0x2549: ╉  0x254a: ╊  0x254b: ╋  0x254c: ╌  0x254d: ╍  0x254e: ╎  0x254f: ╏  0x2550: ═
  0x2551: ║  0x2552: ╒  0x2553: ╓  0x2554: ╔  0x2555: ╕  0x2556: ╖  0x2557: ╗  0x2558: ╘
  0x2559: ╙  0x255a: ╚  0x255b: ╛  0x255c: ╜  0x255d: ╝  0x255e: ╞  0x255f: ╟  0x2560: ╠
  0x2561: ╡  0x2562: ╢  0x2563: ╣  0x2564: ╤  0x2565: ╥  0x2566: ╦  0x2567: ╧  0x2568: ╨
  0x2569: ╩  0x256a: ╪  0x256b: ╫  0x256c: ╬
  #>
  Param(
    [ValidateRange(9473, 9580)]
    [Int]$Minimum = 9473,
    [ValidateRange(9473, 9580)]
    [Int]$Maximum = 9580,
    [Switch]$Value,
    [ValidateScript({ $_ -match '^(#|0x)$' })]
    [ArgumentCompletions('`#', '0x')]
    [String]$ValueFormat = ''
  )
  if (-not ($Minimum -le $Maximum)) {
    $Global:LASTEXITCODE = 255
    Write-Error('Minimum [' + $Minimum + '] is not less than or equal to Maximum [' + $Maximum + '].' )
    return
  }
  $Minimum..$Maximum |
    ForEach-Object {
      $chr = $_
      switch ($Value) {
        $true { $ValueFormat + '{0:x}' -f $chr + ': ' + [char]$chr }
        default { [char]$chr }
      }
    }
}