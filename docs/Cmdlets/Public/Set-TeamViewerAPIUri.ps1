function Set-TeamViewerAPIUri {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $false)]
        [string]$NewUri,
        [Parameter(Mandatory = $false)]
        [bool]$Default
    )

    $config = [TeamViewerConfiguration]::GetInstance()
    $PSDefaultParameterValues = @{'CmdletName:Default' = $true }

    if ($PSCmdlet.ShouldProcess('TeamViewer account')) {
        if ($NewUri) {
            $config.APIUri = $NewUri
            Write-Output "TeamViewer API URL set to: $($config.APIUri)"
        }
        elseif ($Default) {
            $config.APIUri = 'https://webapi.teamviewer.com/api/v1'
            Write-Output "TeamViewer API URL set to: $($config.APIUri)"
        }
    }

}
