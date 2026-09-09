function Set-TeamViewerConditionalAccessTimeOption {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType('TeamViewerPS.ConditionalAccessTimeOption')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Alias('Id', 'TimeOptionId')]
        [guid]
        $TimeOption,

        [Parameter(Mandatory = $true)]
        [string]
        $Name,

        [Parameter(Mandatory = $true)]
        [hashtable]
        $Data
    )

    process {
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/ConditionalAccess/Options/Time/$TimeOption"
        $Body = @{ name = $Name; data = $Data }

        if ($PSCmdlet.ShouldProcess($TimeOption, 'Update conditional access time option')) {
            $Response = Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json -Depth 10))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            Write-Output ($Response | ConvertTo-TeamViewerConditionalAccessTimeOption)
        }
    }
}
