$cwd = split-path $MyInvocation.InvocationName

"$cwd\IronSpec.psm1" | import-module -force

start-specs @args | out-null