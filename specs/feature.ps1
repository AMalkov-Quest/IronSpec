Feature "It should calculate" {
    Given "5" {
        $_ = 5
    }
    
    When "add 5" {
        $_ += 5
    }
    
    Then "should be 10" {
        $_ | should be_equal 60
    }
}