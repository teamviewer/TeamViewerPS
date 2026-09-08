function Remove-TeamViewerConditionalAccessFeatureOption {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Alias('Id', 'FeatureOptionId')]
        [guid]
        $FeatureOption
    )

    process {
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/ConditionalAccess/Options/Features/$FeatureOption"

        if ($PSCmdlet.ShouldProcess($FeatureOption, 'Remove conditional access feature option')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | Out-Null
        }
    }
}
