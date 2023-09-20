function Resolve-TeamViewerUserEmail {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $false)]
        [object]
        $User
    )
    Process {
        if (!$User) {
            return $null
        }
        elseif ($User.PSObject.TypeNames -contains 'TeamViewerPS.User') {
            return $User.Email
        }
        elseif ($User -is [string]) {
            return $User
        }
        else {
            throw "Invalid user email '$User'. Must be either a [TeamViewerPS.User] or [string]."
        }
    }
}
