
function New-TeamViewerRole {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true )]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [Alias('UserRoleName')]
        [string]
        $Name,

        [Parameter(Mandatory = $false)]
        [AllowEmptyCollection()]
        [object[]]
        $Permissions
    )
    Begin {
        $resourceUri = "$(Get-TeamViewerApiUri)/userroles"
        $body = @{
            Name        = $Name
            Permissions = @()
        }

        if ($Permissions) {
            $body.Permissions = @($Permissions)
        }
    }

    Process {
        if ($PSCmdlet.ShouldProcess($Name, 'Create Role')) {
            $response = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Post `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            $result = ($response.Role | ConvertTo-TeamViewerRole)
            Write-Output $result
        }
    }

}
