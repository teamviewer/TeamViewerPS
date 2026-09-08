function Set-TeamViewerConditionalAccessRule {
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

        [Parameter(Mandatory = $true)]
        [hashtable]
        $Property
    )

    process {
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/ConditionalAccess/Rules/$Rule"

        if ($PSCmdlet.ShouldProcess($Rule, 'Update conditional access rule')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Property | ConvertTo-Json -Depth 10))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | Out-Null
        }
    }
}
