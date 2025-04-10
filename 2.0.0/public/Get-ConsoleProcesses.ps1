Function Get-ConsoleProcesses() {
  <#
  .SYNOPSIS
  Get information about the current console.
  .DESCRIPTION
  Get information about the current console and it's spawning parent processes.
  .PARAMETER Parents
  Get both the current process and it's parents.
  Defaults to Self only.
  .EXAMPLE
  PS> Get-ConsoleProcesses
  Name                           Value
  ----                           -----
  Self                           @{ProcessName=pwsh.exe; ExecutablePath=C:\Program Files\PowerShell\7\pwsh.exe; ProcessId=2380; ParentProcessId=19548}
  .EXAMPLE
  PS> Get-ConsoleProcess -Parents
  Name                           Value
  ----                           -----
  Parents                        {@{ProcessName=Tabby.exe; ExecutablePath=C:\Users\<USER>\AppData\Local\Programs\Tabby\Tabby.exe; ProcessId=19548; ParentProcessId=6704}, @{ProcessName=explorer.exe; ExecutablePa… 
  Self                           @{ProcessName=pwsh.exe; ExecutablePath=C:\Program Files\PowerShell\7\pwsh.exe; ProcessId=2380; ParentProcessId=19548}
  .EXAMPLE
  PS> (Get-ConsoleProcesses -Parents).Parents.ProcessName
  Tabby.exe
  explorer.exe
  #>
  Param([Switch]$Parents)
  $getProcess = {
    Param( [Int]$processid = $PID)
    Get-WmiObject Win32_Process |
      Select-Object ProcessName,ExecutablePath,ProcessID,ParentProcessID |
        Where-Object { $_.ProcessID -eq $processid }
  }
  $processes = @{ 'Self' = &$getProcess }
  if ($Parents) {
    $processes.Parents = @()
    $next = $processes.self
    while ($next.ParentProcessID -ne 0) {
      $next = &$getProcess -processid $next.ParentProcessID
      if ($next.ProcessID -ne 0) {
        $processes.Parents += $next
      }
    }
  }
  $processes
}