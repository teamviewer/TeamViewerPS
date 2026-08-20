function Resolve-TeamViewerContactId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $Contact
    )

    process {
        if ($Contact.PSObject.TypeNames -contains 'TeamViewerPS.Contact') {
            Write-Output $Contact.Id
        }
        elseif ($Contact -is [string]) {
            if ($Contact -notmatch 'c[0-9]+') {
                throw "Invalid contact identifier '$Contact'. String must be a contact Id in the form 'c123456789'."
            }

            Write-Output $Contact
        }
        else {
            throw "Invalid contact identifier '$Contact'. Must be either a [TeamViewerPS.Contact] or [string]."
        }
    }
}
