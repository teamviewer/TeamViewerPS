function Resolve-TeamViewerGroupId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $Group
    )

    process {
        if ($Group.PSObject.TypeNames -contains 'TeamViewerPS.Group') {
            Write-Output $Group.Id
        }
        elseif ($Group -is [string]) {
            if ($Group -notmatch 'g[0-9]+') {
                throw "Invalid group identifier '$Group'. String must be a group ID in the form 'g123456789'."
            }

            Write-Output $Group
        }
        else {
            throw "Invalid group identifier '$Group'. Must be either a [TeamViewerPS.Group] or [string]."
        }
    }
}
