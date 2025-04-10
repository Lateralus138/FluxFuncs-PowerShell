Get-ChildItem -Path $PSScriptRoot\private, $PSScriptRoot\public -Filter *.ps1 | ForEach-Object { . $_ }
Get-ChildItem -Path $PSScriptRoot\public\*.ps1 | ForEach-Object { Export-ModuleMember -Function $_.Basename }
