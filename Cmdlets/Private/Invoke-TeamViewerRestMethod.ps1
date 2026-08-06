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

        [System.Object]
        $Body,

        [string]
        $ContentType,

        [System.Management.Automation.PSCmdlet]
        $WriteErrorTo

    )

    if (-not $Headers) {
        $Headers = @{ }
        $PSBoundParameters.Add('Headers', $Headers) | Out-Null
    }

    if ($global:TeamViewerProxyUriSet) {
        $Proxy = $global:TeamViewerProxyUriSet
    }
    elseif ([Environment]::GetEnvironmentVariable('TeamViewerProxyUri') ) {
        $Proxy = [Environment]::GetEnvironmentVariable('TeamViewerProxyUri')
        if ($global:TeamViewerProxyUriRemoved) {
            $Proxy = $null
        }
    }
    if ($Proxy) {
        $PSBoundParameters.Add('Proxy', $Proxy) | Out-Null
    }
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ApiToken)
    $Headers['Authorization'] = "Bearer $([System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr))"
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
    $PSBoundParameters.Remove('ApiToken') | Out-Null
    $PSBoundParameters.Remove('WriteErrorTo') | Out-Null

    $currentTlsSettings = [Net.ServicePointManager]::SecurityProtocol
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $currentProgressPreference = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'

    # Using `Invoke-WebRequest` instead of `Invoke-RestMethod`:
    # There is a known issue for PUT and DELETE operations to hang on Windows Server 2012.
    try {
        # -DateKind String (PS 7.5+) prevents auto-deserialization of date strings to DateTime objects,
        # which avoids locale-dependent day/month swapping and loss of precision.
        $convertParams = if ($PSVersionTable.PSVersion -ge [version]'7.5') {
            @{ DateKind = 'String' } 
        }
        else {
            @{} 
        }
        return ((Invoke-WebRequest -UseBasicParsing @PSBoundParameters).Content | ConvertFrom-Json @convertParams)
    }
    catch {
        $msg = $null
        if ($PSVersionTable.PSVersion.Major -ge 6) {
            $msg = $_.ErrorDetails.Message
        }
        elseif ($_.Exception.Response) {
            $stream = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($stream)
            $reader.BaseStream.Position = 0
            $msg = $reader.ReadToEnd()
        }
        $err = ($msg | ConvertTo-TeamViewerRestError)
        if ($WriteErrorTo) {
            $WriteErrorTo.WriteError(($err | ConvertTo-ErrorRecord))
        }
        else {
            throw $err
        }
    }
    finally {
        [Net.ServicePointManager]::SecurityProtocol = $currentTlsSettings
        $ProgressPreference = $currentProgressPreference
    }
}
