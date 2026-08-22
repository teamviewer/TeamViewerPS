function Resolve-TeamViewerPolicyId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $Policy,

        [Parameter()]
        [switch]
        $AllowNone,

        [Parameter()]
        [switch]
        $AllowInherit
    )

    process {
        if ($Policy.PSObject.TypeNames -contains 'TeamViewerPS.Policy') {
            Write-Output ([guid]($Policy.Id))
        }
        elseif ($Policy -is [string]) {
            if ($Policy -eq 'none' -and $AllowNone) {
                Write-Output 'none'
            }
            elseif ($Policy -eq 'inherit' -and $AllowInherit) {
                Write-Output 'inherit'
            }
            else {
                Write-Output ([guid]$Policy)
            }
        }
        elseif ($Policy -is [guid]) {
            Write-Output $Policy
        }
        else {
            throw "Invalid policy identifier '$Policy'. Must be either a [TeamViewerPS.Policy], [guid] or [string]."
        }
    }
}
