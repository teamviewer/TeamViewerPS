function Resolve-TeamViewerManagedGroupId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $ManagedGroup
    )
    Process {
        if ($ManagedGroup.PSObject.TypeNames -contains 'TeamViewerPS.ManagedGroup') {
            return [guid]$ManagedGroup.Id
        }
        elseif ($ManagedGroup -is [string]) {
            return [guid]$ManagedGroup
        }
        elseif ($ManagedGroup -is [guid]) {
            return $ManagedGroup
        }
        else {
            throw "Invalid managed group identifier '$ManagedGroup'. Must be either a [TeamViewerPS.ManagedGroup], [guid] or [string]."
        }
    }
}
