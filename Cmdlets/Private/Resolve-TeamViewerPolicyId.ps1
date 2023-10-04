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
    Process {
        if ($Policy.PSObject.TypeNames -contains 'TeamViewerPS.Policy') {
            return [guid]$Policy.Id
        }
        elseif ($Policy -is [string]) {
            if ($Policy -eq 'none' -And $AllowNone) {
                return 'none'
            }
            elseif ($Policy -eq 'inherit' -And $AllowInherit) {
                return 'inherit'
            }
            else {
                return [guid]$Policy
            }
        }
        elseif ($Policy -is [guid]) {
            return $Policy
        }
        else {
            throw "Invalid policy identifier '$Policy'. Must be either a [TeamViewerPS.Policy], [guid] or [string]."
        }
    }
}
