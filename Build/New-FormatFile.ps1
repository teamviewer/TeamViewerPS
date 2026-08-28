function New-FormatFile {
    [CmdletBinding(SupportsShouldProcess = $true)]

    param(
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]
        $Path,

        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]
        $Destination

    )

    $File_Content = [xml](Get-Content -Path $Path -Raw)
    if ($PSCmdlet.ShouldProcess($Destination.FullName, 'Generate format file')) {
        $Destination.Directory.Create()
        $File_Content.Save($Destination.FullName)
    }
}
