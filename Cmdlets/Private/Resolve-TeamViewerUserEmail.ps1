function Resolve-TeamViewerUserEmail {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $false)]
        [object]
        $User
    )

    process {
        if (!$User) {
            $null
        }
        elseif ($User.PSObject.TypeNames -contains 'TeamViewerPS.User') {
            $User.Email
        }
        elseif ($User -is [string]) {
            $User
        }
        else {
            throw "Invalid user email '$User'. Must be either a [TeamViewerPS.User] or [string]."
        }
    }
}
