function Invoke-TeamViewerRestMethod {
    <#
        Central REST wrapper for TeamViewer API calls.
        It normalizes headers, injects the bearer token, and converts API responses into PowerShell-friendly objects while preserving the caller's error behavior.
    #>
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
        # Allow proxy configuration to be provided either globally in-memory or via environment variables.
        if ($global:TeamViewerPS_ProxyUri) {
            $Proxy_Uri = $global:TeamViewerPS_ProxyUri
        }
        elseif ([Environment]::GetEnvironmentVariable('TeamViewerPS_ProxyUri') ) {
            $Proxy_Uri = [Environment]::GetEnvironmentVariable('TeamViewerPS_ProxyUri')
        }

        # Initialize the header dictionary and persist it in the bound parameters for the underlying Invoke-RestMethod call.
        if (-not $Headers) {
            $Headers = @{ }

            $PSBoundParameters.Add('Headers', $Headers) | Out-Null
        }

        # Set a consistent user-agent so API traffic is traceable to the module version and PowerShell runtime in use.
        if (-not $Headers.ContainsKey('User-Agent')) {
            $Module_Version = if ($ExecutionContext.SessionState.Module) {
                $ExecutionContext.SessionState.Module.Version
            }
            else {
                '0.0.0'
            }

            $Headers['User-Agent'] = "TeamViewerPS/$Module_Version (PowerShell/$($PSVersionTable.PSVersion))"
        }

        # Reuse the configured proxy when one has been discovered.
        if ($Proxy_Uri) {
            $PSBoundParameters.Add('Proxy', $Proxy_Uri) | Out-Null
        }
    }

    process {
        # Convert the secure token to a mutable string only long enough to build the Authorization header, then clear the unmanaged memory.
        $Token_BinaryString = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ApiToken)
        $Headers['Authorization'] = "Bearer $([System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($Token_BinaryString))"

        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($Token_BinaryString) | Out-Null
        $PSBoundParameters.Remove('ApiToken') | Out-Null
        $PSBoundParameters.Remove('WriteErrorTo') | Out-Null

        # Enforce TLS 1.2 for consistency with the TeamViewer API and restore the original setting in the finally block.
        $TlsSettings_Current = [Net.ServicePointManager]::SecurityProtocol
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        # Avoid noisy progress output from the underlying HTTP call.
        $ProgressPreference_Current = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'

        # Store the raw response body to a temporary file so PowerShell can parse JSON without losing full payload content.
        $Response_FilePath = [System.IO.Path]::GetTempFileName()

        try {
            # PowerShell 7.5 adds a safer date conversion mode for JSON payloads.
            $Convert_Params = if ($PSVersionTable.PSVersion -ge [version]'7.5') {
                @{ DateKind = 'String' }
            }
            else {
                @{}
            }

            $PSBoundParameters.Add('OutFile', $Response_FilePath) | Out-Null

            $null = Invoke-RestMethod @PSBoundParameters

            Write-Output (Get-Content -LiteralPath $Response_FilePath -Raw | ConvertFrom-Json @Convert_Params)
        }
        catch {
            # TeamViewer API errors are surfaced as a structured error object.
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
            # Restore any prior TLS and progress settings regardless of success.
            [Net.ServicePointManager]::SecurityProtocol = $TlsSettings_Current

            $ProgressPreference = $ProgressPreference_Current
            Remove-Item -LiteralPath $Response_FilePath -Force -ErrorAction SilentlyContinue
        }
    }
}
