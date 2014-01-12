resolve-path "$PSScriptRoot\IronSpec-*.psm1" |
    import-module -force
    
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