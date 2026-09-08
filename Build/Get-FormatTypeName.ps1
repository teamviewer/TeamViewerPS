# Extracts the public output type names from cmdlets so the generated format file can apply the correct formatting rules to TeamViewerPS objects.

function Get-FormatTypeName {
    [CmdletBinding()]

    param(
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo[]]
        $PubFunc_Files
    )

    # Parse each public function file and collect any TeamViewerPS.* output types.
    $TypeNames = foreach ($PubFunc_File in $PubFunc_Files) {
        $Tokens = $null
        $ParseErrors = $null

        # Read the AST so we can inspect attributes without executing the script.
        $Ast = [System.Management.Automation.Language.Parser]::ParseFile(
            $PubFunc_File.FullName,
            [ref]$Tokens,
            [ref]$ParseErrors
        )

        $Ast.FindAll({
                param($Node)

                # Look for [OutputType('TeamViewerPS.*')] attributes and keep their values.
                $Node -is [System.Management.Automation.Language.AttributeAst] -and $Node.TypeName.Name -eq 'OutputType'
            }, $true) | ForEach-Object {
            $_.PositionalArguments | Where-Object {
                $_ -is [System.Management.Automation.Language.StringConstantExpressionAst] -and $_.Value -like 'TeamViewerPS.*'
            } | Select-Object -ExpandProperty Value
        }
    }

    # Remove duplicates to keep the generated format XML concise.
    @($TypeNames | Sort-Object -Unique)
}
