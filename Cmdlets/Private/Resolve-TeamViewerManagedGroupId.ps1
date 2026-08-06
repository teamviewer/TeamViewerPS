function Resolve-TeamViewerManagedGroupId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $ManagedGroup
    )

    process {
        if ($ManagedGroup.PSObject.TypeNames -contains 'TeamViewerPS.ManagedGroup') {
            [guid]$ManagedGroup.Id
        }
        elseif ($ManagedGroup -is [string]) {
            [guid]$ManagedGroup
        }
        elseif ($ManagedGroup -is [guid]) {
            $ManagedGroup
        }
        else {
            throw "Invalid managed group identifier '$ManagedGroup'. Must be either a [TeamViewerPS.ManagedGroup], [guid] or [string]."
        }
    }
}
