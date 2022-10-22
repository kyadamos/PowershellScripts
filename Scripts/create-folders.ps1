## Create new folders in a directory based on the content of a text file

# Text file with folder names
$FolderList = "..\FolderList.txt"

# Destination folder
$DestinationFolder = "..\Folders"

foreach ($Folder in Get-Content $FolderList) {
	new-item -Path $DestinationFolder -ItemType Directory -Name $Folder
}