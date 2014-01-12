function Execute-Script {
    process {
        write-host $_
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
            write-host
        }
    }
    end {
        
    }
}

export-moduleMember -function Start-Specs