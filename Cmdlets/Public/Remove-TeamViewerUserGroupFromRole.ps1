function Remove-TeamViewerUserGroupFromRole {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([pscustomobject])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias('UserGroupId')]
        [Alias('Id')]
        [object]
        $UserGroup
    )

    begin {
        $null = $APIToken
        $ResourceUri = "$(Get-TeamViewerAPIUri)/userroles/unassign/usergroup"
        $Body = @{
            UserGroupId = $UserGroup
        }
    }


    process {
        if ($PSCmdlet.ShouldProcess($UserGroupId, 'Unassign User Group from user role')) {
            $Result = Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $ResourceUri `
                -Method Post `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop
            Write-Output ($Result)
        }
    }
}
