import-module "$PSScriptRoot\IronSpec-assert.psm1" -force

function Feature {
param(
    [Parameter(Mandatory = $true, Position = 0)] $name,
    $tags=@(),
    [Parameter(Mandatory = $true, Position = 1)]
    [ScriptBlock] $fixture
)
	& $fixture 
}

function Scenario {
param(
    $name,
    [ScriptBlock] $fixture
)
    begin {
        $scenario = @{}
        $scenario.steps = New-Object System.Collections.Queue
    }
    
    process {
        & $fixture
    }
    
    end {
        $steps = ""
        foreach($step in $scenario.steps) {
            $step.Keys | % {
                Write-Host -ForegroundColor green $_
                Write-Host -ForegroundColor green $step[$_]
                $steps += $step[$_].ToString()
            }
        }
        
        [ScriptBlock] $test = [scriptblock]::Create($steps)
        
        try{
            & $test
        } catch {
            Write-Host $_.Exception.Message
        }
    }
}

function Step {
param(
    $name, 
    [ScriptBlock] $test = $(Throw "No test script block is provided. (Have you put the open curly brace on the next line?)")
)
    $scenario.steps.Enqueue(@{$name=$test})
}

function Given {
param(
    $name, 
    [ScriptBlock] $test
)
    Step $name $test
}

function And {
param(
    $name, 
    [ScriptBlock] $test
)
    Step $name $test
}

function When {
param(
    $name, 
    [ScriptBlock] $test
)
    Step $name $test
}

function Then {
param(
    $name, 
    [ScriptBlock] $test
)
    Step $name $test
}

function Save-Scenario {
param(
    $scenario
)
    

    Setup-TestFunction
    . $IronSpecTempDir\spec.ps1
    try{
        [object]$test=(get-variable -name test -scope 1 -errorAction Stop).value
    }
    catch { 
        Write-Host $_.Exception.Message
    }
    
    try{
        test
    } catch {
        Write-Host $_.Exception.Message
    }
}

function Setup-TestFunction {
@"
function test {
$test
}
"@ | Microsoft.Powershell.Utility\Out-File $IronSpecTempDir\spec.ps1
}

export-moduleMember -function `
    Then,
    When,
    And,
    Given,
    Feature,
    Scenario