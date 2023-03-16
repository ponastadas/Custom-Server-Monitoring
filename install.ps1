
# Define the script path
$script_path = "/home/monitoring/output.ps1"

# Download the script from GitHub
$url = "add github url to output.ps1"
$output_path = "/home/monitoring/output.ps1"
Invoke-WebRequest -Uri $url -OutFile $output_path

# Install PowerShell if it's not already installed
if (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) {
    sudo apt-get update
    sudo apt-get install -y powershell
}

# Create the service file
$service_file = @"
[Unit]
Description=Server Monitoring Service

[Service]
#Type=simple
ExecStart=/usr/bin/pwsh $script_path
Restart=always

[Install]
WantedBy=multi-user.target
"@

# Write the service file to disk
$service_file_path = "/etc/systemd/system/serverMonitor.service"
Set-Content -Path $service_file_path -Value $service_file

# Reload the systemd daemon and start the service
sudo systemctl daemon-reload
sudo systemctl restart serverMonitor.service

# Verify that the service is running
$service_status = sudo systemctl status serverMonitor.service
Write-Host $service_status

# Launch the monitoring script
Write-Output "Launching monitoring script..."
$monitoring_script = "/home/monitoring/output.ps1"
