$hasTestNetConnection = [bool](Get-Command Test-NetConnection -ErrorAction SilentlyContinue)
$hasTestConnection = [bool](Get-Command Test-Connection -ErrorAction SilentlyContinue | Where-Object { $_.Version -ge 5.1 })

function Test-TcpConnection {
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $Hostname,

        [Parameter(Mandatory = $true)]
        [int]
        $Port
    )

    if (-Not $hasTestNetConnection -And -Not $hasTestConnection) {
        throw "No suitable cmdlet found for testing the TeamViewer network connectivity."
    }

    $oldProgressPreference = $global:ProgressPreference
    $global:ProgressPreference = 'SilentlyContinue'

    if ($hasTestNetConnection) {
        Test-NetConnection -ComputerName $Hostname -Port $Port -InformationLevel Quiet -WarningAction SilentlyContinue
    }
    elseif ($hasTestConnection) {
        Test-Connection -TargetName $Hostname -TcpPort $Port -Quiet -WarningAction SilentlyContinue
    }
    else {
        $false
    }

    $global:ProgressPreference = $oldProgressPreference
}
