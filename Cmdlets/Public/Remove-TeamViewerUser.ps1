function Remove-TeamViewerUser {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserId } )]
        [Alias('UserId')]
        [Alias('Id')]
        [object]
        $User,

        [Parameter()]
        [switch]
        $Permanent
    )

    process {
        $userId = $User | Resolve-TeamViewerUserId
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/users/$userId"

        if ($Permanent) {
            $Resource_Uri += '?isPermanentDelete=true'
        }

        if ($PSCmdlet.ShouldProcess($userId, 'Remove user')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
