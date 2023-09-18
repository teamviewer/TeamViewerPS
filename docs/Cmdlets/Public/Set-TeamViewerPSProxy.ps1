$global:TeamViewerProxyUriSet = $null

function Set-TeamViewerPSProxy {
    [CmdletBinding(SupportsShouldProcess =$true)]
    param (
        [Parameter(Mandatory=$true)]
        [Uri]
        $ProxyUri
    )

    if($PSCmdlet.ShouldProcess($ProxyUri,"Sets proxy for WebAPI")){
    $global:TeamViewerProxyUriSet = $ProxyUri
    $global:TeamViewerProxyUriRemoved = $false
    $global:TeamViewerProxyUriRemoved | Out-Null

    [Environment]::SetEnvironmentVariable("TeamViewerProxyUri", $ProxyUri, "User")

    Write-Output "Proxy set to $TeamViewerProxyUriSet"
    }
}

