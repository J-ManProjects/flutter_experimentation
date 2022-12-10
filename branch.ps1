# Organize the input parameters.
param (
	[Alias('h')]
	[Switch]$help,

	[Alias('l')]
	[Switch]$link,

	[Alias('n')]
	[String]$new,

	[Alias('d')]
	[String]$delete
)



# Show the help dialogue.
function Help {
	Write-Host ""
	Write-Host "Usage: branch.ps1 [option] [value]"
	Write-Host "arguments:"
	Write-Host "   -h, -help:     Shows the help dialogue"
	Write-Host "   -l, -link:     Links all remote branches with local branches"
	Write-Host "   -n, -new:      Creates and links a new branch, locally and remotely"
	Write-Host "   -d, -delete:   Deletes the specified branch, locally and remotely"
	Write-Host ""
	Write-Host "Opens the help dialogue if no arguments are provided."
	Write-Host ""
	exit 1
}



# Get list of all local and remote branches.
function ScanBranches {
	$branches = git branch -a
	$index = $branches.IndexOf($branches -like "*HEAD*")
	
	# Get all local branches.
	$local = New-Object 'String[]' ($index)
	for ($i = 0; $i -lt $local.Length; $i++) {
		$local[$i] = ($branches[$i] -split " ")[-1]
	}
	
	# Get all remote branches.
	$j = $index + 1
	$remote = New-Object 'String[]' ($branches.Length - $j)
	for ($i = 0; $i -lt $remote.Length; $i++) {
		$remote[$i] = ($branches[$j] -split "remotes/origin/")[-1]
		$j++
	}

	return $local, $remote
}



# Link all local and remote branches.
function LinkBranches($local, $remote) {

	# If branches don't exist locally, create them.
	foreach ($branch in $remote) {
		if (-not $local.Contains($branch)) {
			git branch $branch
			git branch --set-upstream-to=origin/$branch $branch
		}
	}

	# If branches don't exist remotely, create them.
	foreach ($branch in $local) {
		if (-not $remote.Contains($branch)) {
			git push origin $branch
			git branch --set-upstream-to=origin/$branch $branch
		}
	}
}



# Creates a new branch both locally and remotely.
function CreateNewBranch($branch) {
	$branch = $branch.ToLower().Replace(" ", "_")
	$local, $remote = ScanBranches
	$exists = $true

	# If local branch does not exist, create it.
	if (-not ($local.Contains($branch))) {
		git branch $branch
		$exists = $false
	}

	# If remote branch does not exist, create it.
	if (-not ($remote.Contains($branch))) {
		git push origin $branch
		$exists = $false
	}

	# Show error if branch already exists. Otherwise, link remote and local branch.
	if ($exists) {
		Write-Host "Error! Branch '$($branch)' already exists." -ForegroundColor DarkRed
	} else {
		git branch --set-upstream-to=origin/$branch $branch
	}
}



# Deletes a branch both locally and remotely.
function DeleteBranch($branch) {
	$branch = $branch.ToLower().Replace(" ", "_")
	$local, $remote = ScanBranches
	$missing = $true

	# If local branch exists, delete it.
	if ($local.Contains($branch)) {
		git branch -D $branch
		$missing = $false
	}

	# If remote branch exists, delete it.
	if ($remote.Contains($branch)) {
		git push origin --delete $branch
		$missing = $false
	}

	# If neither exists, show error message.
	if ($missing) {
		Write-Host "Error! Branch '$($branch)' does not exist." -ForegroundColor DarkRed
	}
}




# The main operations of the script starts here.
################################################################################

# If an argument has not been provided, show the help dialogue.
if (-not ($new -or $link -or $delete)) {
	$help = $true
}

# If help is requested, show the help menu and exit.
if ($help) {
	Help
}

# Link branches
if ($link) {
	$local, $remote = ScanBranches
	LinkBranches $local $remote
}

# Create a new branch.
if ($new) {
	CreateNewBranch($new)
}

# Delete the specified branch.
if ($delete) {
	DeleteBranch($delete)
}