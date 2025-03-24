function Resolve-TeamViewerOrganizationalUnitId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [PSObject]
        $OrganizationalUnit
    )

    Process {
        if ($OrganizationalUnit.PSObject.TypeNames -contains 'TeamViewerPS.OrganizationalUnit') {
            Write-Output $OrganizationalUnit.Id
        }
        elseif ($OrganizationalUnit -is [string]) {
            if ($OrganizationalUnit -notmatch '(?im)^[{(]?[0-9A-F]{8}[-]?(?:[0-9A-F]{4}[-]?){3}[0-9A-F]{12}[)}]?$') {
                throw "Invalid organizational unit identifier '$OrganizationalUnit'. String must be an UUID."
            }

            Write-Output $OrganizationalUnit
        }
        else {
            throw "Invalid organizational unit identifier '$OrganizationalUnit'. Must be either a [TeamViewerPS.OrganizationalUnit] or [UUID]."
        }
    }
}
