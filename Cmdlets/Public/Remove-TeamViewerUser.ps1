function Remove-TeamViewerUser {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

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
        $ResourceUri = "$(Get-TeamViewerApiUri)/users/$userId"

        if ($Permanent) {
            $ResourceUri += '?isPermanentDelete=true'
        }

        if ($PSCmdlet.ShouldProcess($userId, 'Remove user')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $ResourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
