function Set-TeamViewerManagedDevice {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('DeviceId')]
        [object]
        $Device,

        [Alias('Alias')]
        [string]
        $Name,

        [ValidateScript( { $_ | Resolve-TeamViewerPolicyId } )]
        [Alias('PolicyId')]
        [object]
        $Policy,

        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias('ManagedGroupId')]
        [object]
        $ManagedGroup,

        [Parameter(ParameterSetName = 'UpdateDescription')]
        [Alias('Description')]
        [string]
        $deviceDescription
    )
    begin {
        $body = @{}

        if ($Name) {
            $body['name'] = $Name
        }
        if ($Policy) {
            $body['teamviewerPolicyId'] = $Policy | Resolve-TeamViewerPolicyId
        }
        elseif ($ManagedGroup) {
            $body['managedGroupId'] = $ManagedGroup | Resolve-TeamViewerManagedGroupId
        }

        if ($Policy -and $ManagedGroup) {
            $PSCmdlet.ThrowTerminatingError(
                ('The combination of parameters -Policy and -ManagedGroup is not allowed.' | `
                    ConvertToErrorRecord -ErrorCategory InvalidArgument))
        }

        if ($deviceDescription -and ($Policy -or $ManagedGroup)) {
            $PSCmdlet.ThrowTerminatingError(
                ('The parameter -deviceDescription cannot be combined with -Policy or -ManagedGroup.' |
                ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
        }

        if ($deviceDescription) {
            $body['deviceDescription'] = $deviceDescription
        }

        if ($body.Count -eq 0) {
            $PSCmdlet.ThrowTerminatingError(
                ('The given input does not change the managed device.' | `
                    ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
        }
    }
    process {
        $deviceId = $Device | Resolve-TeamViewerManagedDeviceId
        $resourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$deviceId"

        switch ($PsCmdlet.ParameterSetName) {
            'UpdateDescription' {
                $resourceUri += '/description'
            }
        }

        if ($PSCmdlet.ShouldProcess($Device.ToString(), 'Change managed device entry')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
