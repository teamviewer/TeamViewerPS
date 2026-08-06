function Resolve-TeamViewerUserId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $User
    )

    process {
        if ($User.PSObject.TypeNames -contains 'TeamViewerPS.User') {
            $User.Id
        }
        elseif ($User -is [string]) {
            if ($User -notmatch 'u[0-9]+') {
                throw "Invalid user identifier '$User'. String must be a user ID in the form 'u123456789'."
            }
            $User
        }
        else {
            throw "Invalid user identifier '$User'. Must be either a [TeamViewerPS.User] or [string]."
        }
    }
}
