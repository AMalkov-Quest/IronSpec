function to_list {
    begin {
        $list = @()
    }
    process {
        $list += ,$_
    }
    end {
        return $list
    }
}

function write-assertion ($name, $result) {
    write-output @{
        type = 'assertion';
        assertion = $name;
        result = $result
    }
}

function eval {
    process {
        if ($_ -is [scriptblock]) {
            try { return ,(&$_) }
            catch { return $_ }
        }
        else { return ,$_ }
    }
}

function humanize {
    process {
        $text = "$_" `
            -replace '[{}]', '' `
            -replace '[_-]', ' ' `
            -replace '\s{2,}', ' '
        return $text.Trim()
    }
}

function format-assertion ($actual, $func, $tail) {
    $actual_value = $actual | eval
    if ("$actual" -ne "$actual_value") {
        $actual = "$actual ($actual_value)"
    }
    $items = $actual, $func, $tail | humanize
    return $items -join ' '
}

function call-function ($func, $func_args) {
    if ($func -ne 'throw'-and
        $func -ne 'not') {
        $func_args = @($func_args | eval)
    }
    return &$func @func_args
}

function should {
    $func = $args[0]
    $input_list = $input | to_list
    $name = format-assertion $input_list 'should' $args
    $args[0] = $input_list
    $result = call-function $func $args
    write-assertion $name $result
}

function be_equal ($actual, $expected) {
    if ($actual -is [enum]) { return $actual -eq $expected }
    return [System.Object]::Equals($actual, $expected)
}

export-moduleMember -function `
    should,
    be_equal