function Get-FormatTypeName {
    [CmdletBinding()]

    param(
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo[]]
        $PubFunc_Files
    )

    $TypeNames = foreach ($PubFunc_File in $PubFunc_Files) {
        $Tokens = $null
        $ParseErrors = $null

        $Ast = [System.Management.Automation.Language.Parser]::ParseFile(
            $PubFunc_File.FullName,
            [ref]$Tokens,
            [ref]$ParseErrors
        )

        $Ast.FindAll({
                param($Node)

                $Node -is [System.Management.Automation.Language.AttributeAst] -and $Node.TypeName.Name -eq 'OutputType'
            }, $true) | ForEach-Object {
            $_.PositionalArguments | Where-Object {
                $_ -is [System.Management.Automation.Language.StringConstantExpressionAst] -and $_.Value -like 'TeamViewerPS.*'
            } | Select-Object -ExpandProperty Value
        }
    }

    @($TypeNames | Sort-Object -Unique)
}
