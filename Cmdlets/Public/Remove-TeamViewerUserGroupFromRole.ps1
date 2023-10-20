function Remove-TeamViewerUserGroupFromRole {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias('UserGroupId')]
        [Alias('Id')]
        [object]
        $UserGroup
    )

    Begin {
        $null = $ApiToken
        $resourceUri = "$(Get-TeamViewerApiUri)/userroles/unassign/usergroup"
        $body = @{
            UserGroupId = $UserGroup
        }
    }


    Process {
        if ($PSCmdlet.ShouldProcess($UserGroupId, 'Unassign User Group from user role')) {
            $result = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Post `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop
            Write-Output ($result)
        }
    }
}
