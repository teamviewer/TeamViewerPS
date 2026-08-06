BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:TVPS_PSFiles = @(Get-ChildItem -Path "$($Script:Module_RootPath)\*.ps1" -Recurse -ErrorAction SilentlyContinue)
}

Context 'Test-PowershellFilesValidity' {
    $Test_Case = $Script:TVPS_PSFiles | Where-Object { $_.fullname } | ForEach-Object {
        @{
            FilePath = $_.fullname
            FileName = $_.Name
        }
    }

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
