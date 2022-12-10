# Organize the input parameters.
param (
	[Alias('h')]
	[Switch]$hard,

	[Alias('s')]
	[Switch]$soft,

	[Alias('r')]
	[Switch]$remote
)

# Validate the input arguments.
if ($hard -and $soft) {
	Write-Host "Error! Cannot perform a hard and soft reset simultaneously!" -ForegroundColor DarkRed
	exit 1
}

# Get list of commits and extract previous hash and message.
$logs = git log --pretty=oneline
$hash = $logs[1].split()[0]
$message = "$($logs[1])".Substring(41)

# Format the local commit text to display below.
$localText = &{if ($hard) {"hard-"} elseif ($soft) {"soft-"} else {""}}

# Format the remote commit text to display below.
$remoteText = &{if ($remote) {"REMOTE reset and a "} else {""}}

# Display details of previous commit.
Write-Host "Performing a $($remoteText)LOCAL $($localText)reset to the previous commit..." -ForegroundColor Green
Write-Host "message:  $message"
Write-Host "hash:     $hash"
Write-Host "================================================================================" -ForegroundColor DarkGray

# Reset local branch to previous commit.
if ($hard) {
	git reset --hard $hash
} elseif ($soft) {
	git reset --soft $hash
} else {
	git reset $hash
}

# If desired, reset remote branch to previous commit.
if ($remote) {
	git push -f
}