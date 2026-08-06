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
            [guid]$Policy.Id
        }
        elseif ($Policy -is [string]) {
            if ($Policy -eq 'none' -and $AllowNone) {
                'none'
            }
            elseif ($Policy -eq 'inherit' -and $AllowInherit) {
                'inherit'
            }
            else {
                [guid]$Policy
            }
        }
        elseif ($Policy -is [guid]) {
            $Policy
        }
        else {
            throw "Invalid policy identifier '$Policy'. Must be either a [TeamViewerPS.Policy], [guid] or [string]."
        }
    }
}
