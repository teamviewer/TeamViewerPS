function Get-TeamViewerUserByRole {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.RoleUserMembership')]

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

    $Resource_Uri = "$(Get-TeamViewerAPIUri)/userroles/assignments/account?userRoleId=$Role"
    $Parameters = $null

    do {
        $Response = Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $Resource_Uri `
            -Method Get `
            -Body $Parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        if ($Response.ContinuationToken) {
            $Resource_Uri += '&continuationToken=' + $Response.ContinuationToken
        }

        Write-Output ($Response.AssignedToUsers | ConvertTo-TeamViewerRoleUserMembership )
    } while ($Response.ContinuationToken)
}
