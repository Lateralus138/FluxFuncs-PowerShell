Function New-Password() {
  <#
    .SYNOPSIS
    Generate random passwords.
    .DESCRIPTION
    Generate random passwords with several options using Get-SeureRandom.
    .PARAMETER Length
    The length of the password. Defaults to 12.
    .PARAMETER Clipboard
    Send output to the clipboard.
    .PARAMETER Extended
    Use the extended version of special characters (non-alphanumeric: #!~()_:;<>{}[]).
    The default is a compatible list (#!~()_);
    .PARAMETER Full
    Use every special character that exists (non-alphanumeric).
    The default is a compatible list (#!~()_);
    .PARAMETER NoSpecial
    No special characters.
    .PARAMETER NoUppercase
    No uppercase characters.
    .PARAMETER NoLowercase
    No lowercase characters.
    .PARAMETER NoNumbers
    No numbers.
    .EXAMPLE
    PS> New-Password -Length 20
    PZLYLb1~SlQf3(Y92xmz
    .EXAMPLE
    PS> np 20 -NoSpecial
    kxVYSORTcwCardm6gQes
    .EXAMPLE
    PS> np 20 -Full
    RCUj(B5e<_-BG{m(vWI}
  #>
  Param(
    [Int]$Length = 12,
    [Switch]$Clipboard,
    [Switch]$Extended,
    [Switch]$Full,
    [Switch]$NoSpecial,
    [Switch]$NoUppercase,
    [Switch]$NoLowercase,
    [Switch]$NoNumbers
  )
  $noupper_ = $PSBoundParameters.ContainsKey('NoUppercase')
  $nolower_ = $PSBoundParameters.ContainsKey('NoLowercase')
  $nospecial_ = $PSBoundParameters.ContainsKey('NoSpecial')
  $nonumbers_ = $PSBoundParameters.ContainsKey('NoNumbers')
  $extended_ = $PSBoundParameters.ContainsKey('Extended')
  $full_ = $PSBoundParameters.ContainsKey('Full')
  if (($noupper_) -and ($nolower_) -and ($nospecial_) -and ($nonumbers_)) {
    $global:LASTEXITCODE = 255
    'You can not use all -No* character switches as nothing will be generated.'
    return
  }
  if (($extended_) -and ($full_)) {
    $global:LASTEXITCODE = 254
    'Extended and Full special characters can not be used together.'
    return   
  }
  $singles = @()
  $passwordArray = @()
  $password = ''
  $offset = 2
  $special = ''
  $compatibleSpecial = '#!~()_' * 2
  $extendSpecial = '#!~()_:;<>{}[]'
  $charactersUpper = @(for ($index = 0; $index -lt 26; $index++) { [Char](65 + $index) })
  $charactersLower = @(for ($index = 0; $index -lt 26; $index++) { [Char](97 + $index) })
  $charactersNumber = 0..9
  $fullSpecial = @(for ($index = 0; $index -lt 15; $index++) { [Char](33 + $index) })
  $fullSpecial += @(for ($index = 0; $index -lt 7; $index++) { [Char](58 + $index) })
  $fullSpecial += @(for ($index = 0; $index -lt 6; $index++) { [Char](91 + $index) })
  $fullSpecial += @(for ($index = 0; $index -lt 4; $index++) { [Char](123 + $index) })
  $characters = @()
  if (-not ($noupper_)) {
    $singles += @($($charactersUpper | Get-SecureRandom))
    $characters += $charactersUpper
  } else { $offset-- }
  if (-not ($nolower_)) {
    $singles += $($charactersLower | Get-SecureRandom)
    $characters += $charactersLower
  } else { $offset-- }
  if (-not ($nonumbers_)) {
    $characters += $charactersNumber
  }
  if (-not ($nospecial_)) {
    if (-not ($extended_ -or $full_)) {
      $special = $compatibleSpecial.ToCharArray()
    } else {
      if ($extended_) {
        $special = $extendSpecial.ToCharArray()
      } else {
        $special = $fullSpecial
      }
    }
    $characters += $special
  }
  if ($singles.Length -gt 0) {
    $singlesSorted = @($($singles | Sort-Object { Get-SecureRandom }))
    $password = $singlesSorted[0]
    $passwordArray += @($singlesSorted[1])
  }
  for ($index = 0; $index -lt ($Length - $offset); $index++) {
    $passwordArray += $($characters | Get-SecureRandom)
  }
  $passwordArraySorted = @($($passwordArray | Sort-Object { Get-SecureRandom }))
  $password += $($passwordArraySorted -Join '')
  if ($Clipboard) {
    Set-Clipboard -Value "$password"
  }
  $password
}
Set-Alias -Name np -Value New-Password -Description 'Shortcut to New-Password'