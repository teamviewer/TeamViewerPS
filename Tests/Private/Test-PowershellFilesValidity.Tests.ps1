$Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
$Test_Case = @(Get-ChildItem -Path "$Module_RootPath\*.ps1" -Recurse -ErrorAction SilentlyContinue) |
    Where-Object { $_.FullName } |
    ForEach-Object { @{ FilePath = $_.FullName; FileName = $_.Name } }

Context 'Test-PowershellFilesValidity' {

    It 'Script should be a valid Powershell file' -TestCases $Test_Case {
        param(
            $FilePath
        )

        $FilePath | Should -Exist

        $Test_FileContent = Get-Content -Path $FilePath -ErrorAction Stop

        $Test_Error = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($Test_FileContent, [ref]$Test_Error)

        $Test_Error.Count | Should -Be 0
    }
}
