function Remove-TeamViewerConditionalAccessTimeOption {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Alias('Id', 'TimeOptionId')]
        [guid]
        $TimeOption
    )

    process {
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/ConditionalAccess/Options/Time/$TimeOption"

        if ($PSCmdlet.ShouldProcess($TimeOption, 'Remove conditional access time option')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | Out-Null
        }
    }
}
