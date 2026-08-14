function Resolve-TeamViewerManagedGroupId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $ManagedGroup
    )

    process {
        if ($ManagedGroup.PSObject.TypeNames -contains 'TeamViewerPS.ManagedGroup') {
            Write-Output ([guid]($ManagedGroup.Id))
        }
        elseif ($ManagedGroup -is [string]) {
            Write-Output ([guid]$ManagedGroup)
        }
        elseif ($ManagedGroup -is [guid]) {
            Write-Output $ManagedGroup
        }
        else {
            throw "Invalid managed group identifier '$ManagedGroup'. Must be either a [TeamViewerPS.ManagedGroup], [guid] or [string]."
        }
    }
}
