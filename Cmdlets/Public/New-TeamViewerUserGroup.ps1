function New-TeamViewerUserGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType('TeamViewerPS.UserGroup')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [string]
        $Name
    )

    begin {
        $resourceUri = "$(Get-TeamViewerApiUri)/usergroups"
        $body = @{ name = $Name }
    }

    process {
        if ($PSCmdlet.ShouldProcess($Name, 'Create user group')) {
            $response = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Post `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop
            Write-Output ($response | ConvertTo-TeamViewerUserGroup)
        }
    }
}
