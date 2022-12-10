# Organize the input parameters.
param (
	[Alias('h')]
	[Switch]$help,

	[Alias('e')]
	[Switch]$explorer,

	[Alias('v')]
	[Switch]$vscode,

	[Alias('a')]
	[Switch]$android,

	[Alias('g')]
	[Switch]$github
)

# If help is requested, show the help menu and exit.
if ($help) {
	Write-Host ""
	Write-Host " Usage: openRepo.ps1 [option]"
	Write-Host " optional arguments:"
	Write-Host "   -h, -help:      Shows the help dialogue"
	Write-Host "   -e, -explorer:  Opens the current directory in Windows Explorer"
	Write-Host "   -v, -vscode:    Opens the current directory in VSCode"
	Write-Host "   -a, -android:   Opens the current directory in Android Studio"
	Write-Host "   -g, -github:    Opens the GitHub repository in default browser"
	Write-Host ""
	Write-Host " Will open Windows Explorer, VSCode, and the GitHub link"
	Write-Host " by default if no arguments are provided."
	Write-Host ""
	exit 1
}

# Set all to true if no parameters were given.
if (-not ($explorer -or $vscode -or $android -or $github)) {
	$explorer = $true
	$vscode = $true
	$android = $true
	$github = $true
}

# Open directory in Windows Explorer.
if ($explorer) {
	Invoke-Item .
}

# Open directory in VSCode.
if ($vscode) {
	Start-Process -WindowStyle Hidden code .
}

# Open directory in android.
if ($android) {
	studio64.exe .
}

# Open link to GitHub repository.
if ($github) {
	$url = ((cat ".git\config" | Select-String "url") -split "\s")[-1]
	Start-Process $url
}