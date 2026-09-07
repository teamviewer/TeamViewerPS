function Remove-TeamViewerUserTFA {
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
        $User
    )

    process {
        $userId = $User | Resolve-TeamViewerUserId
        $ResourceUri = "$(Get-TeamViewerAPIUri)/users/$userId/tfa"


        if ($PSCmdlet.ShouldProcess($userId, 'Disable TFA')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $ResourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
