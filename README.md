# FluxFuncs

Flux Functions is a generic package of Powershell functions to aid in my workflows that I can't categorize into any other package.

---

## About

### Description

List of random Powershell functions I use often.

### Function List (2.0.1)

|Name|Description|
|:---|----------:|
|Add-EscapedQuotes|Wrap strings in escaped single or double quotation marks.|
|Convert-DecimalToHexadecimal|Convert decimal integers to hexadecimal format with a few options.|
|Format-PathEnvironment|Print the $Env:PATH variable split by the ';' delimeter.|
|Get-AppPackageNames|Get App Package names only. This is just a shortcut to: @(Get-AppPackage | ForEach-Object { $_.Name })|
|Get-AreaOfCircle|Get the area of a circle by radius or diameter.|
|Get-BoxCharacters|List all Unicode box characters with a few options.|
|Get-BoxDate|Get the current date and time in a box with various options.|
|Get-ConsoleProcesses|Get information about the current console and it's spawning parent processes.|
|Get-DiffUnique|Print unique differences in two files with Compare-Object and Format-List.|
|Get-FileSizesInDirectory|Get the combined size of all files in a directory or directories recursively.|
|Get-FullPaths|Get the full paths of all files and/or dirctories in a directory with a few options such as directories or files only and recursive and depth.|
|Get-GitHubStats|Get a user's GitHub statistics via https://github-readme-stats.vercel.app/ with various custom options.|
|Get-KeyInfo|Get a pressed key's information object.|
|Get-MinecraftChunkRange|Get the upper left and lower right X and Z coordinates of a chunk by providing one set of coordinates within that chunk.|
|Get-Parent|Get an object of an path with an object of it's parent.|
|Get-PathString|Get strings from paths using Resolve-Path.|
|Get-ProcessHwnd|Get all window handles of a running process.|
|New-Autorun|Create a basic Autorun file especially for ISO containers.|
|New-Password|Generate random passwords with several options using Get-SeureRandom.|
|New-RecycleBin|Create the Recycle Bin directory in Windows.|
|Remove-EmptyDirectories|Remove empty directories from a path. Recursive by default.|
|Restart-Explorer|Restart Windows Explorer.|
|Set-Cursor|Enable or disable a terminal cursor in Powershell.|

## License

[GPLV3](./LICENSE)

### Excerpt

>                     GNU GENERAL PUBLIC LICENSE
>                       Version 3, 29 June 2007
> Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/> Everyone is permitted to copy and distribute verbatim copies of this license document, but changing it is not allowed.

>                               Preamble

> The GNU General Public License is a free, copyleft license for software and other kinds of works.

> The licenses for most software and other practical works are designed to take away your freedom to share and change the works.  By contrast, the GNU General Public License is intended to guarantee your freedom to share and change all versions of a program--to make sure it remains free software for all its users.  We, the Free Software Foundation, use the GNU General Public License for most of our software; it applies also to any other work released this way by its authors.  You can apply it to your programs, too...