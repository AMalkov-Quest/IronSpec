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
    $scenario = @{}
    $scenario.steps = New-Object System.Collections.Queue

    & $fixture
    
    $steps = ""
    foreach($step in $scenario.steps) {
        $step.Keys | % {
            Write-Host -ForegroundColor green $_
            $steps += $step[$_].ToString()
        }
    }
    
    [ScriptBlock] $test = [scriptblock]::Create($steps)
    Write-Host -ForegroundColor green $test
    
    try{
        & $test
    } catch {
        Write-Host $_.Exception.Message
    }
}

function Step {
param(
    $name, 
    [ScriptBlock] $test = $(Throw "No test script block is provided. (Have you put the open curly brace on the next line?)")
)
    $scenario.steps.Enqueue(@{$name=$test})
}

function __Step {
param(
    $name, 
    [ScriptBlock] $test = $(Throw "No test script block is provided. (Have you put the open curly brace on the next line?)")
)
    Write-Host -ForegroundColor green $name

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