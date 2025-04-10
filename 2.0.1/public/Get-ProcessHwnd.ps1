Function Get-ProcessHwnd() {
  <#
  .SYNOPSIS
  Get all window handles of a running process.
  .DESCRIPTION
  Get all window handles of a running process.
  .PARAMETER ProcessName
  The name of the process.
  .INPUTS
  Pipeline. List of process names as strings.
  .OUTPUTS
  System.ValueType:IntPtr
  .EXAMPLE
  PS> Get-ProcessHwnd explorer
  3017330
  .EXAMPLE
  PS> '0x{0:X}' -f $Get-ProcessHwnd explorer)
  0x2E0A72
  #>
  Param(
    [ValidateScript({ Get-Process -Name $_ })]
    [Parameter(HelpMessage = 'Provide a process name without the .exe')]
    [String]$ProcessName,
    [ValidateScript({ Get-Process -Name $_ })]
    [Parameter(HelpMessage = 'Provide a process name without the .exe', ValueFromPipeline)]
    [String]$ProcessNameFromPipe
  )
  begin {
    if ($PSBoundParameters.ContainsKey('ProcessName')) {
      (Get-Process -Name "$ProcessName" -ErrorAction SilentlyContinue).MainWindowHandle
    }
  }
  process {
    if ($PSBoundParameters.ContainsKey('ProcessNameFromPipe')) {
      (Get-Process -Name "$ProcessNameFromPipe" -ErrorAction SilentlyContinue).MainWindowHandle
    }
  }
}