function Resolve-TeamViewerOrganizationalUnitId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]$OrganizationalUnit
    )

    Process {
        if ($OrganizationalUnit.PSObject.TypeNames -contains 'TeamViewerPS.OrganizationalUnit') {
            return $OrganizationalUnit.Id
        }
        elseif ($OrganizationalUnit -is [string]) {
            # ToDo
            if ($OrganizationalUnit -notmatch 'g[0-9]+') {
                throw "Invalid organizational unit identifier '$OrganizationalUnit'. String must be a organizational unit Id in the form 'g123456789'."
            }

            return $OrganizationalUnit
        }
        else {
            throw "Invalid organizational unit identifier '$OrganizationalUnit'. Must be either a [TeamViewerPS.OrganizationalUnit] or [string]."
        }
    }
}
