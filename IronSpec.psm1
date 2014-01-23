"$PSScriptRoot\IronSpec-*.psm1" | Resolve-Path | import-module -force

$localappdata = $env:LOCALAPPDATA
$home = "IronSpec"
$global:IronSpecHomePath = "$localappdata\$home"
$global:IronSpecTempDir = [System.IO.Path]::GetFullPath($IronSpecHomePath)

function Initialize-Specs {
    if (!(Test-Path IronSpecTempDir:)) {
        New-Item -Name $home -Path $localappdata -Type Container -Force | Out-Null
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