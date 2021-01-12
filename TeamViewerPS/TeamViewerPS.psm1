
$PublicFunctions = @( Get-ChildItem -Path "$PSScriptRoot/Public/*.ps1" -ErrorAction SilentlyContinue )
$PrivateFunctions = @( Get-ChildItem -Path "$PSScriptRoot/Private/*.ps1" -ErrorAction SilentlyContinue )

@($PublicFunctions + $PrivateFunctions) | ForEach-Object { . $_.FullName }
Export-ModuleMember -Function $PublicFunctions.BaseName -Alias *
