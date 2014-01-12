function Feature {
param(
        [Parameter(Mandatory = $true, Position = 0)] $name,
        $tags=@(),
        [Parameter(Mandatory = $true, Position = 1)]
        [ScriptBlock] $fixture
)
	& $fixture
}