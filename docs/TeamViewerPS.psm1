$ModuleTypes = @( Get-ChildItem -Path "$PSScriptRoot/TeamViewerPS.Types.ps1" -ErrorAction SilentlyContinue )
$PublicFunctions = @( Get-ChildItem -Path "$PSScriptRoot/Cmdlets/Public/*.ps1" -ErrorAction SilentlyContinue )
$PrivateFunctions = @( Get-ChildItem -Path "$PSScriptRoot/Cmdlets/Private/*.ps1" -ErrorAction SilentlyContinue )

@($ModuleTypes + $PublicFunctions + $PrivateFunctions) | ForEach-Object { . $_.FullName }
Export-ModuleMember -Function $PublicFunctions.BaseName -Alias *
