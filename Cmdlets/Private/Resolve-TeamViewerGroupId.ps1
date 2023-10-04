function Resolve-TeamViewerGroupId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $Group
    )
    Process {
        if ($Group.PSObject.TypeNames -contains 'TeamViewerPS.Group') {
            return $Group.Id
        }
        elseif ($Group -is [string]) {
            if ($Group -notmatch 'g[0-9]+') {
                throw "Invalid group identifier '$Group'. String must be a group ID in the form 'g123456789'."
            }
            return $Group
        }
        else {
            throw "Invalid group identifier '$Group'. Must be either a [TeamViewerPS.Group] or [string]."
        }
    }
}
