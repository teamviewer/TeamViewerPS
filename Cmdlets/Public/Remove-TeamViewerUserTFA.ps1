function Remove-TeamViewerUserTFA {
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
        $User
    )

    process {
        $userId = $User | Resolve-TeamViewerUserId
        $ResourceUri = "$(Get-TeamViewerApiUri)/users/$userId/tfa"


        if ($PSCmdlet.ShouldProcess($userId, 'Disable TFA')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $ResourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
