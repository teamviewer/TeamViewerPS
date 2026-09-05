function Invoke-TeamViewerRestMethod {
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [uri]
        $Uri,

        [Microsoft.PowerShell.Commands.WebRequestMethod]
        $Method,

        [System.Collections.IDictionary]
        $Headers,

        [object]
        $Body,

        [string]
        $ContentType,

        [System.Management.Automation.PSCmdlet]
        $WriteErrorTo

    )

    begin {
        if ($global:TeamViewerPS_ProxyUri) {
            $Proxy_Uri = $global:TeamViewerPS_ProxyUri
        }
        elseif ([Environment]::GetEnvironmentVariable('TeamViewerPS_ProxyUri') ) {
            $Proxy_Uri = [Environment]::GetEnvironmentVariable('TeamViewerPS_ProxyUri')
        }

        if (-not $Headers) {
            $Headers = @{ }

            $PSBoundParameters.Add('Headers', $Headers) | Out-Null
        }

        if (-not $Headers.ContainsKey('User-Agent')) {
            $Module_Version = if ($ExecutionContext.SessionState.Module) {
                $ExecutionContext.SessionState.Module.Version
            }
            else {
                '0.0.0'
            }

            $Headers['User-Agent'] = "TeamViewerPS/$Module_Version (PowerShell/$($PSVersionTable.PSVersion))"
        }

        if ($Proxy_Uri) {
            $PSBoundParameters.Add('Proxy', $Proxy_Uri) | Out-Null
        }
    }

    process {
        $Token_BinaryString = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ApiToken)
        $Headers['Authorization'] = "Bearer $([System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($Token_BinaryString))"

        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($Token_BinaryString) | Out-Null
        $PSBoundParameters.Remove('ApiToken') | Out-Null
        $PSBoundParameters.Remove('WriteErrorTo') | Out-Null

        $TlsSettings_Current = [Net.ServicePointManager]::SecurityProtocol
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $ProgressPreference_Current = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'

        try {
            # -DateKind String (PS 7.5+) prevents auto-deserialization of date strings to DateTime objects which avoids locale-dependent day/month swapping and loss of precision.
            $Convert_Params = if ($PSVersionTable.PSVersion -ge [version]'7.5') {
                @{ DateKind = 'String' }
            }
            else {
                @{}
            }

            Write-Output (Invoke-RestMethod @PSBoundParameters)
        }
        catch {
            $Err_Msg = $null

            if ($PSVersionTable.PSVersion.Major -ge 6) {
                $Err_Msg = $_.ErrorDetails.Message
            }
            elseif ($_.Exception.Response) {
                $Err_Stream = $_.Exception.Response.GetResponseStream()
                $Err_Reader = New-Object System.IO.StreamReader($Err_Stream)
                $Err_Reader.BaseStream.Position = 0
                $Err_Msg = $Err_Reader.ReadToEnd()
            }

            $Err = ($Err_Msg | ConvertTo-TeamViewerRestError)

            if ($WriteErrorTo) {
                $WriteErrorTo.WriteError(($Err | ConvertTo-ErrorRecord))
            }
            else {
                throw $Err
            }
        }
        finally {
            [Net.ServicePointManager]::SecurityProtocol = $TlsSettings_Current

            $ProgressPreference = $ProgressPreference_Current
        }
    }
}
