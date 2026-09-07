function Add-TeamViewerSSOInclusion {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerSSODomainId } )]
        [Alias('Id', 'DomainId', 'SSODomainId', 'SSODomain')]
        [object]
        $Domain,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Alias('EmailAddress')]
        [string[]]
        $Email
    )

    begin {
        $Domain_Id = $Domain | Resolve-TeamViewerSSODomainId

        $Resource_Uri = "$(Get-TeamViewerAPIUri)/ssoDomain/$Domain_Id/inclusion"
        $Emails_ToAdd = @()
        $null = $APIToken # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472

        function Invoke-TeamViewerRestMethodInternal {
            $Body = @{
                emails = @($Emails_ToAdd)
            }

            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Post `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }

    process {
        if ($PSCmdlet.ShouldProcess($Email, 'Add SSO inclusion')) {
            $Emails_ToAdd += $Email
        }

        if ($Emails_ToAdd.Length -eq 100) {
            Invoke-TeamViewerRestMethodInternal
            $Emails_ToAdd = @()
        }
    }
    end {
        if ($Emails_ToAdd.Length -gt 0) {
            Invoke-TeamViewerRestMethodInternal
        }
    }
}
