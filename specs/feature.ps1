Feature "Addition" {
<#
In order to avoid silly mistakes
As a math idiot
I want to be told the sum of two numbers
#>
    Scenario "Add two numbers" {
    
        Given "I have entered 50 into the calculator" {
            $summand1 = 50
			Write-Host $summand1
        }
   
        And "I have entered 70 into the calculator" {
            $summand2 = 70
			Write-Host $summand1
        }
        
        When "I press add" {
            $result = $summand1 + $summand2
			Write-Host $result
        }
        
        Then "The result should be 120 on the screen" {
            $result | should be_equal 120
			Write-Host $result
        }
    }
}