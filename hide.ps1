# Organize the input parameters.
param (
	[Alias('h')]
	[Switch]$help,

	[Alias('p')]
	[String]$path,

	[Alias('d')]
	[int]$depth
)

# If help is requested, show the help menu and exit.
if ($help) {
	Write-Host ""
	Write-Host "Usage: hide.ps1 [option] [value] ..."
	Write-Host "optional arguments:"
	Write-Host "   -h, -help:   Shows the help dialogue"
	Write-Host "   -p, -path:   Select the path of files and folders to hide"
	Write-Host "   -d, -depth:  Select the recursive depth for traversing subfolders"
	Write-Host "Example:"
	Write-Host "   hide.ps1"
	Write-Host "   hide.ps1 -p 'C:/Users'"
	Write-Host "   hide.ps1 -p 'C:/Users' -d 3"
	Write-Host "Empty [option] will use default values"
	Write-Host "Default Configuration:"
	Write-Host "-- Path:  <present working directory>"
	Write-Host "-- Depth: 0"
	Write-Host ""
	exit 1
}

# If an argument has not been provided, use default values.
if (-not $path) {
	$path = [String]$pwd
}
if (-not $depth) {
	$depth = 0
}

# Validate parameters.
$validPath = Test-Path -PathType Container -Path $path
$validDepth = $depth -match "^[0-9]+$"

# Continue if valid parameters
if ($validPath -and $validDepth) {

	# Get array of all files and folders current working directory.
	[array]$files = (Get-ChildItem $path -File)
	[array]$folders = (Get-ChildItem $path -Directory)

	# Hide all files that start with a '.'
	foreach ($file in $files) {
		if ("$($file.Name)".StartsWith('.')) {
			Write-Output "> $path\$($file.Name)"
			$file.attributes += "Hidden"
		}
	}

	# Hide all folders that start with a '.' and traverse the rest.
	foreach ($folder in $folders) {
		if ("$($folder.Name)".StartsWith('.')) {
			Write-Output "> $path\$($folder.Name)"
			$folder.attributes += "Hidden"
		} elseif ($depth -gt 0) {
			.\hide.ps1 -p "$path\$($folder.Name)" -d $($depth-1)
		}
	}
}