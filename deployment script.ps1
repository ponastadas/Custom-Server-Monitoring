# Define the URL for the install script
$installScriptUrl = 'https://raw.githubusercontent.com/ponastadas/Custom-Server-Monitoring/main/install.ps1'

# Define the path for the install script
$installScriptPath = '/home/monitoring/install.ps1'

# Define the path for the report file
$reportFilePath = '/var/www/html/report.html'

# Define the path for the backup directory
$backupDirectory = '/home/monitoring/backup'

# Create the directory /home/monitoring if it doesn't already exist
if (-not (Test-Path '/home/monitoring')) {
    New-Item -ItemType Directory -Path '/home/monitoring'
}

# Create the backup directory if it doesn't already exist
if (-not (Test-Path $backupDirectory)) {
    New-Item -ItemType Directory -Path $backupDirectory
}

# Create a backup file name with the date-time stamp
$backupFileName = '{0:yyyy-MM-dd_HH-mm-ss}_report.html' -f (Get-Date)

# Check if the report file exists and make a backup copy if it does
if (Test-Path $reportFilePath) {
    Copy-Item $reportFilePath "$backupDirectory/$backupFileName"
}

# Download the install script and save it to /home/monitoring/install.ps1
Invoke-WebRequest -Uri $installScriptUrl -OutFile $installScriptPath -UseBasicParsing

# Run the install script using PowerShell in a new process
Start-Process pwsh -ArgumentList $installScriptPath -NoNewWindow -Wait
