function New-TeamViewerUserGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType('TeamViewerPS.UserGroup')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [string]
        $Name
    )

    begin {
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/usergroups"
        $Body = @{ name = $Name }
    }

    process {
        if ($PSCmdlet.ShouldProcess($Name, 'Create user group')) {
            $Response = Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Post `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            Write-Output ($Response | ConvertTo-TeamViewerUserGroup)
        }
    }
}
