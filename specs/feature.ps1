Feature "Addition" {
<#
In order to avoid silly mistakes
As a math idiot
I want to be told the sum of two numbers
#>
    Scenario "Add two numbers" {
    
        Given "I have entered 50 into the calculator" {
            $_ = 50
        }
   
        And "I have entered 70 into the calculator" {
            $_ = 70
        }
        
        When "I press add" {
            $_ = 50 + 70
        }
        
        Then "The result should be 120 on the screen" {
            $_ | should be_equal 120
        }
    }
}