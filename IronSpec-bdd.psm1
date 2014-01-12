function Feature {
param(
    [Parameter(Mandatory = $true, Position = 0)] $name,
    $tags=@(),
    [Parameter(Mandatory = $true, Position = 1)]
    [ScriptBlock] $fixture
)
	& $fixture
    #Write-Host $fixture 
}

function Scenario {
param(
    $name,
    [ScriptBlock] $fixture
)
    & $fixture
}

function Step {
param(
    $name, 
    [ScriptBlock] $test = $(Throw "No test script block is provided. (Have you put the open curly brace on the next line?)")
)
    Write-Host -ForegroundColor green $name
    
    Setup-TestFunction
    . $TestDrive\temp.ps1
    try{
        [object]$test=(get-variable -name test -scope 1 -errorAction Stop).value
    }
    catch { 
        Write-Host $_.Exception.Message
    }
    
    try{
        temp
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
function temp {
$test
}
"@ | Microsoft.Powershell.Utility\Out-File $TestDrive\temp.ps1
}

export-moduleMember -function `
    Then,
    When,
    And,
    Given,
    Feature,
    Scenario