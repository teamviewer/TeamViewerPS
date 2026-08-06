function Resolve-TeamViewerManagerId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $Manager
    )

    process {
        if ($Manager.PSObject.TypeNames -contains 'TeamViewerPS.Manager') {
            [guid]$Manager.Id
        }
        elseif ($Manager -is [string]) {
            [guid]$Manager
        }
        elseif ($Manager -is [guid]) {
            $Manager
        }
        else {
            throw "Invalid manager identifier '$Manager'. Must be either a [TeamViewerPS.Manager], [guid] or [string]."
        }
    }
}
