$global:TeamViewerProxyUriSet = $null

function Set-TeamViewerPSProxy {
    param (
        [Parameter(Mandatory=$true)]
        [Uri]
        $ProxyUri
    )

    $global:TeamViewerProxyUriSet = $ProxyUri
    $global:TeamViewerProxyUriRemoved = $false
    $global:TeamViewerProxyUriRemoved | Out-Null 

    [Environment]::SetEnvironmentVariable("TeamViewerProxyUri", $ProxyUri, "User")

    Write-Output "Proxy set to $TeamViewerProxyUriSet"
}

