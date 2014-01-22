"$PSScriptRoot\IronSpec-*.psm1" | Resolve-Path | import-module -force

121 | should be_equal 120

$global:IronSpecTempPath = "$env:Temp\IronSpec"
$global:IronSpecTempDir = [System.IO.Path]::GetFullPath($IronSpecTempPath)

function Initialize-Specs {
    if (!(Test-Path IronSpecTempDir:)) {
        New-Item -Name IronSpec -Path $env:Temp -Type Container -Force | Out-Null
        New-PSDrive -Name IronSpecTempDir -PSProvider FileSystem -Root "$IronSpecTempPath" -Scope Global | Out-Null
    }
}
    
function Execute-Script {
    process {
        $pop = $false
        if ($_ -is [io.path] -and (test-path $_)) {
            $file = split-path $_ -leaf
            split-path $_ | push-location
            $_ = $file
            $pop = $true
        }
        
        try { & $_ }
        finally {
            if ($pop) {
                pop-location
            }
        }
    }
}

function Start-Specs {
    begin {
        $results = @()
		Initialize-Specs
    }
    process {
        
        $_ = ".\specs\*.ps1"
        try {
            resolve-path $_ | execute-script
        }
        catch {
            write-host $_.Exception.Message
        }
    }
    end {
        
    }
}

export-moduleMember -function Start-Specs