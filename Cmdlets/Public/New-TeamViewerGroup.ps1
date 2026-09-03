function New-TeamViewerGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType('TeamViewerPS.Group')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [string]
        $Name,

        [Parameter()]
        [ValidateScript( { $_ | Resolve-TeamViewerPolicyId } )]
        [Alias('PolicyId')]
        [object]
        $Policy
    )

    $Body = @{ name = $Name }

    if ($Policy) {
        $Body['policy_id'] = ($Policy | Resolve-TeamViewerPolicyId).ToString()
    }

    $ResourceUri = "$(Get-TeamViewerApiUri)/groups"

    if ($PSCmdlet.ShouldProcess($Name, 'Create group')) {
        $Response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $ResourceUri `
            -Method Post `
            -ContentType 'application/json; charset=utf-8' `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop
        Write-Output ($Response | ConvertTo-TeamViewerGroup)
    }
}
