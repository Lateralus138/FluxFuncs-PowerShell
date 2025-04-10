Function Get-MinecraftChunkRange {
  <#
  .SYNOPSIS
  Get the bounds coordinates of a chunk.
  .DESCRIPTION
  Get the upper left and lower right X and Z coordinates of a chunk by providing
  one set of coordinates within that chunk.
  .PARAMETER X
  Initial X coordinate of position within the chunk.
  .PARAMETER Z
  Initial Z coordinate of position within the chunk.
  .PARAMETER Object
  return the result as an object rather than a string.
  .EXAMPLE
  PS> Get-MinecraftChunkRange -X 3 -Z -686
  From: 0,-688 To: 15,-673
  .EXAMPLE
  PS> $coords = Get-MinecraftChunkRange 3 -686 -Object
  PS> $coords
  Name                           Value
  ----                           -----
  X1                             0
  X2                             15
  Z1                             -688
  Z2                             -673 
  #>
  Param
  (
    [Parameter(Mandatory = $true)][int]$X,
    [Parameter(Mandatory = $true)][int]$Z,
    [Switch]$Object
  )
  while (($X % 16) -ne 0) { $X-- }
  while (($Z % 16) -ne 0) { $Z-- }
  $object_ = @{ 'X1' = $X; 'Z1' = $Z; 'X2' = ($X + 15); 'Z2' = ($Z + 15) }
  switch ($Object) {
    $true { $object_ }
    default {
      'From: ' + [String]($object_.X1) + ',' + [String]($object_.Z1) +
      ' To: ' + [String]($object_.X2) + ',' +[String]($object_.Z2)
    }
  }
}