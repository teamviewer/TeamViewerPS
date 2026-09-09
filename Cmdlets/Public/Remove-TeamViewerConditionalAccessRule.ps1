function Remove-TeamViewerConditionalAccessRule {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Alias('Id', 'RuleId')]
        [string]
        $Rule,

        [string]
        $ModificationReason
    )

    process {
        $Body = @{ id = $Rule }

        if ($PSBoundParameters.ContainsKey('ModificationReason')) {
            $Body['modification_reason'] = $ModificationReason
        }

        $Resource_Uri = "$(Get-TeamViewerAPIUri)/ConditionalAccess/Rules"

        if ($PSCmdlet.ShouldProcess($Rule, 'Remove conditional access rule')) {
            Invoke-TeamViewerJsonRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Delete `
                -Body ($Body | ConvertTo-Json) `
                -CallerCmdlet $PSCmdlet | Out-Null
        }
    }
}
