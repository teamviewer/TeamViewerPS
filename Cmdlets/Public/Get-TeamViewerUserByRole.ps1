function Get-TeamViewerUserByRole {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.RoleAssignedUser')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerRoleId } )]
        [Alias('Role')]
        [string]
        $RoleId
    )

    $ResourceUri = "$(Get-TeamViewerApiUri)/userroles/assignments/account?userRoleId=$RoleId"
    $Parameters = $null

    do {
        $Response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
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
