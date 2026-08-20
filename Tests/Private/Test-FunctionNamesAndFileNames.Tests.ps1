BeforeDiscovery {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_CmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets'

    $Script:FunctionTestCases = @('Private', 'Public') | ForEach-Object {
        $FunctionType = $_
        $FunctionPath = Join-Path -Path $Module_CmdletsPath -ChildPath $FunctionType

        Get-ChildItem -Path $FunctionPath -Filter '*.ps1' -File | ForEach-Object {
            @{
                FunctionName = $_.BaseName
                FunctionPath = $FunctionPath
                FunctionType = $FunctionType
            }
        }
    }
}

Describe 'Test-FunctionNamesAndFileNames' {
    It '<FunctionType> function file name matches its top-level function name: <FunctionName>' -TestCases $FunctionTestCases {
        param(
            [string]$FunctionName,
            [string]$FunctionPath
        )

        $FunctionFilePath = Join-Path -Path $FunctionPath -ChildPath "$FunctionName.ps1"

        $Tokens = $null
        $ParseErrors = $null

        $Ast = [System.Management.Automation.Language.Parser]::ParseFile($FunctionFilePath, [ref]$Tokens, [ref]$ParseErrors)

        $ParseErrors | Should -BeNullOrEmpty

        $TopLevelFunctions = @($Ast.FindAll({
                    param($Node)
                    if ($Node -isnot [System.Management.Automation.Language.FunctionDefinitionAst] -or
                        $Node.Parent -isnot [System.Management.Automation.Language.NamedBlockAst]) {
                        return $false
                    }

                    $Parent = $Node.Parent.Parent
                    while ($Parent) {
                        if ($Parent -is [System.Management.Automation.Language.FunctionDefinitionAst] -or
                            $Parent -is [System.Management.Automation.Language.FunctionMemberAst]) {
                            return $false
                        }

                        $Parent = $Parent.Parent
                    }

                    return $true
                }, $true))

        $TopLevelFunctions | Should -HaveCount 1
        $TopLevelFunctions[0].Name | Should -Be $FunctionName
    }
}
