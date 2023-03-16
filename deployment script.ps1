# Define the URL for the install script
$installScriptUrl = 'https://raw.githubusercontent.com/ponastadas/Custom-Server-Monitoring/main/install.ps1'

# Define the path for the install script
$installScriptPath = '/home/monitoring/install.ps1'

# Create the directory /home/monitoring if it doesn't already exist
if (-not (Test-Path '/home/monitoring')) {
    New-Item -ItemType Directory -Path '/home/monitoring'
}

# Download the install script and save it to /home/monitoring/install.ps1
Invoke-WebRequest -Uri $installScriptUrl -OutFile $installScriptPath -UseBasicParsing

# Run the install script using PowerShell in a new process
Start-Process pwsh -ArgumentList $installScriptPath -NoNewWindow -Wait
