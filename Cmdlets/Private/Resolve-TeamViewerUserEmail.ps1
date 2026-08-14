function Resolve-TeamViewerUserEmail {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $false)]
        [object]
        $User
    )

    process {
        if (!$User) {
            Write-Output $null
        }
        elseif ($User.PSObject.TypeNames -contains 'TeamViewerPS.User') {
            Write-Output $User.Email
        }
        elseif ($User -is [string]) {
            Write-Output $User
        }
        else {
            throw "Invalid user email '$User'. Must be either a [TeamViewerPS.User] or [string]."
        }
    }
}
