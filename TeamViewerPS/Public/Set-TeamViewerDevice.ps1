function Set-TeamViewerDevice {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = "Default")]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerDeviceId } )]
        [Alias("DeviceId")]
        [Alias("Id")]
        [object]
        $Device,

        [Parameter(ParameterSetName = "ChangeGroup")]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias("GroupId")]
        [object]
        $Group,

        [Parameter(ParameterSetName = "ChangePolicy")]
        [ValidateScript( { $_ | Resolve-TeamViewerPolicyId -AllowInherit -AllowNone } )]
        [Alias("PolicyId")]
        [object]
        $Policy,

        [Parameter()]
        [Alias("Alias")]
        [string]
        $Name,

        [Parameter()]
        [string]
        $Description,

        [Parameter()]
        [securestring]
        $Password
    )
    Begin {
        $body = @{}

        if ($Name) {
            $body['alias'] = $Name
        }
        if ($Description) {
            $body['description'] = $Description
        }
        if ($Password) {
            $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
            $body['password'] = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
            [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
        }
        if ($Group) {
            $body['groupid'] = $Group | Resolve-TeamViewerGroupId
        }
        if ($Policy) {
            $body['policy_id'] = $Policy | Resolve-TeamViewerPolicyId -AllowNone -AllowInherit
        }

        if ($body.Count -eq 0) {
            $PSCmdlet.ThrowTerminatingError(
                ("The given input does not change the device." | `
                        ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
        }
    }
    Process {
        $deviceId = $Device | Resolve-TeamViewerDeviceId
        $resourceUri = "$(Get-TeamViewerApiUri)/devices/$deviceId"

        if ($PSCmdlet.ShouldProcess($Device.ToString(), "Change device entry")) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Put `
                -ContentType "application/json; charset=utf-8" `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
