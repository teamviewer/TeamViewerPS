function Resolve-TeamViewerManagerId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $Manager
    )
    Process {
        if ($Manager.PSObject.TypeNames -contains 'TeamViewerPS.Manager') {
            return [guid]$Manager.Id
        }
        elseif ($Manager -is [string]) {
            return [guid]$Manager
        }
        elseif ($Manager -is [guid]) {
            return $Manager
        }
        else {
            throw "Invalid manager identifier '$Manager'. Must be either a [TeamViewerPS.Manager], [guid] or [string]."
        }
    }
}
