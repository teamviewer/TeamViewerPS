# Copies the module format XML to the build output while preserving the original file content.
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

    # Load the format definition as XML so it can be reused in the packaged module.
    $File_Content = [xml](Get-Content -Path $Path -Raw)

    if ($PSCmdlet.ShouldProcess($Destination.FullName, 'Generate format file')) {
        # Ensure the destination folder exists before writing the format file.
        $Destination.Directory.Create()
        $File_Content.Save($Destination.FullName)
    }
}
