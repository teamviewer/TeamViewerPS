function Set-TeamViewerConditionalAccessFeatureOption {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType('TeamViewerPS.ConditionalAccessFeatureOption')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Alias('Id', 'FeatureOptionId')]
        [guid]
        $FeatureOption,

        [Parameter(Mandatory = $true)]
        [string]
        $Name,

        [Parameter(Mandatory = $true)]
        [hashtable]
        $Data
    )

    process {
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/ConditionalAccess/Options/Features/$FeatureOption"
        $Body = @{ name = $Name; data = $Data }

        if ($PSCmdlet.ShouldProcess($FeatureOption, 'Update conditional access feature option')) {
            $Response = Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json -Depth 10))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            Write-Output ($Response | ConvertTo-TeamViewerConditionalAccessFeatureOption)
        }
    }
}
