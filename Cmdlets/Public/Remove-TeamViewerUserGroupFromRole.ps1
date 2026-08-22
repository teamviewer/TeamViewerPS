function Remove-TeamViewerUserGroupFromRole {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([pscustomobject])]

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

    begin {
        $null = $ApiToken
        $ResourceUri = "$(Get-TeamViewerApiUri)/userroles/unassign/usergroup"
        $Body = @{
            UserGroupId = $UserGroup
        }
    }


    process {
        if ($PSCmdlet.ShouldProcess($UserGroupId, 'Unassign User Group from user role')) {
            $Result = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
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
