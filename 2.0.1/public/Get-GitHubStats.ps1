
# TODO Finish the C++ version of Get-GitHubStats
Function Get-GitHubStats {
  <#
    .SYNOPSIS
    Get a user's GitHub statistics in a badge.
    .Description
    Get a user's GitHub statistics via https://github-readme-stats.vercel.app/
    with various custom options.
    .PARAMETER UserName
    The user's name.
    .PARAMETER BackgroundColor
    The background color of the badge.
    .PARAMETER TextColor
    The Foreground color of the badge.
    .PARAMETER NoIcons
    The badge has no icons.
    .PARAMETER Theme
    One of the following themes: dark, radical, merko, gruvbox, tokyonight,
    onedark, cobalt, synthwave, highcontrast, and dracula.
    .PARAMETER BorderRadius
    The radius of the badge's corners.
    .PARAMETER CustomTitle
    The title of the badge.
    .PARAMETER Open
    Open in a web browser for test display. It returns the url link by default.
    .EXAMPLE
    PS> Get-GitHubStats -UserName Lateralus138
    https://github-readme-stats.vercel.app/api?username=Lateralus138&bg_color=1F1F1F&text_color=F0F0F0&show_icons=true&theme=dracula&border_radius=24&custom_title=Lateralus138%27s+GitHub+Stats
    .LINK
    https://github-readme-stats.vercel.app/
  #>
  Param(
    [ValidateScript({$_.Length -gt 0 -and $_ -notmatch '^.*[\s\t]+.*$'})]
    [Parameter(Mandatory = $true)]
    [String]$UserName,
    [ValidateScript({$_ -match '^[0-9a-fA-F]{6}$'})]
    [String]$BackgroundColor = "1F1F1F",
    [ValidateScript({$_ -match '^[0-9a-fA-F]{6}$'})]`
    [String]$TextColor = "F0F0F0",
    [Switch]$NoIcons,
    [ValidateScript({$_.Length -gt 0 -and $_ -notmatch '^.*[\s\t]+.*$'})]
    [ValidateSet('dark', 'radical', 'merko', 'gruvbox', 'tokyonight', 'onedark', 'cobalt', 'synthwave', 'highcontrast', 'dracula')]
    [String]$Theme = "dracula",
    [ValidateScript({$_ -match '^[0-9]+$'})]
    [String]$BorderRadius = "24",
    [ValidateScript({$_.Length -gt 0 -and $_ -notmatch '^.*[\s\t]+.*$'})]
    [String]$CustomTitle = $UserName.Replace(' ', '%27') + "%27s+GitHub+Stats",
    [Switch]$Open
  )
  $url = @(
    'https://github-readme-stats.vercel.app/api'
    '?username=' + $UserName.Replace(' ', '%27')
    '&bg_color=' + $BackgroundColor
    '&text_color=' + $TextColor
    '&show_icons=' + $(switch ($NoIcons) { $true { 'false' }; default { 'true' } })
    '&theme=' + $Theme
    '&border_radius=' + $BorderRadius
    '&custom_title=' + $CustomTitle) -Join ''
  if (-not ($Open)) { $url } else { rundll32 url,OpenURL "$url" }
}
Set-Alias -Name 'gghs'`
          -Value 'Get-GitHubStats'`
          -Description 'One of the following themes: dark, radical, merko, gruvbox, tokyonight, onedark, cobalt, synthwave, highcontrast, and dracula.'