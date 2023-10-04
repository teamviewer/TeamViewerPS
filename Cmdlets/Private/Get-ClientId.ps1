function Get-ClientId {
    if (Test-Path -Path 'HKLM:\SOFTWARE\Wow6432Node\TeamViewer') {
        $mainKey = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\TeamViewer'
        $id = [int]$mainKey.ClientID
    }
    elseif (Test-Path -Path 'HKLM:\Software\TeamViewer') {
        $mainKey = Get-ItemProperty -Path 'HKLM:\Software\TeamViewer'
        $id = [int]$mainKey.ClientID
    }
    return $id
}
