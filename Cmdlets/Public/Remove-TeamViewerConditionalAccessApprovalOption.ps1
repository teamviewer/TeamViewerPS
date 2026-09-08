function Remove-TeamViewerConditionalAccessApprovalOption {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Alias('Id', 'ApprovalOptionId')]
        [guid]
        $ApprovalOption
    )

    process {
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/ConditionalAccess/Options/Approval/$ApprovalOption"

        if ($PSCmdlet.ShouldProcess($ApprovalOption, 'Remove conditional access approval option')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | Out-Null
        }
    }
}
