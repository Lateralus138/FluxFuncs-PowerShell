Function Set-Cursor {
  <#
  .SYNOPSIS
  Toggle terminal cursor.
  .DESCRIPTION
  Enable or disable a terminal cursor in Powershell.
  .PARAMETER Visible
  Enable the cursor. Disable is the default value.
  #>
  Param([Switch]$Visible)
  [System.Console]::CursorVisible = $Visible
}