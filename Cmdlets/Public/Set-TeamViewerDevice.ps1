function Set-TeamViewerDevice {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ChangeProperties')]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerDeviceId } )]
        [Alias('DeviceId')]
        [Alias('Id')]
        [object]
        $Device,

        [Parameter(ParameterSetName = 'ChangeGroup')]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias('GroupId')]
        [object]
        $Group,

        [Parameter(ParameterSetName = 'ChangePolicy')]
        [ValidateScript( { $_ | Resolve-TeamViewerPolicyId -AllowInherit -AllowNone } )]
        [Alias('PolicyId')]
        [object]
        $Policy,

        [Parameter()]
        [Alias('Alias')]
        [string]
        $Name,

        [Parameter()]
        [string]
        $Description,

        [Parameter()]
        [securestring]
        $Password
    )

    begin {
        $Body = @{}

        if ($Name) {
            $Body['alias'] = $Name
        }

        if ($Description) {
            $Body['description'] = $Description
        }

        if ($Password) {
            $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
            $Body['password'] = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
            [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
        }

        if ($Group) {
            $Body['groupid'] = $Group | Resolve-TeamViewerGroupId
        }

        if ($Policy) {
            $Body['policy_id'] = ($Policy | Resolve-TeamViewerPolicyId -AllowNone -AllowInherit).ToString()
        }

        if ($Body.Count -eq 0) {
            $PSCmdlet.ThrowTerminatingError(
                ('The given input does not change the device.' | `
                    ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
        }
    }

    process {
        $DeviceId = $Device | Resolve-TeamViewerDeviceId
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/devices/$DeviceId"

        if ($PSCmdlet.ShouldProcess($DeviceId, 'Change device entry')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
