function Get-TeamViewerUserByRole {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.RoleAssignedUser')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerRoleId } )]
        [Alias('Id', 'RoleId')]
        [string]
        $Role
    )

    $ResourceUri = "$(Get-TeamViewerAPIUri)/userroles/assignments/account?userRoleId=$Role"
    $Parameters = $null

    do {
        $Response = Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $ResourceUri `
            -Method Get `
            -Body $Parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        if ($Response.ContinuationToken) {
            $ResourceUri += '&continuationToken=' + $Response.ContinuationToken
        }

        Write-Output ($Response.AssignedToUsers | ConvertTo-TeamViewerRoleAssignedUser )
    } while ($Response.ContinuationToken)
}
