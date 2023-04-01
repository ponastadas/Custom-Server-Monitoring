# Define the script path
$script_path = "/home/monitoring/output.ps1"

# Download the script and style.css from GitHub
$output_path = "/home/monitoring/output.ps1"
$style_url = "https://raw.githubusercontent.com/ponastadas/Custom-Server-Monitoring/main/style.css"
$style_path = "/var/www/html/style.css"

try {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ponastadas/Custom-Server-Monitoring/main/output.ps1" -OutFile $output_path -ErrorAction Stop
    Invoke-WebRequest -Uri $style_url -OutFile $style_path -ErrorAction Stop
} catch {
    Write-Error "Error downloading files from GitHub: $_"
    Exit 1
}

# Move the existing report.html to archive if it exists
$report_html_path = "/var/www/html/report.html"
$archive_folder = "/home/monitoring/archive"
$timestamp = "{0:yyyy-MM-dd_HH-mm-ss}" -f (Get-Date)
$archive_file_path = "$archive_folder/report_$timestamp.html"

if (Test-Path -Path $report_html_path) {
    if (!(Test-Path -Path $archive_folder -PathType Container)) {
        New-Item -ItemType Directory -Path $archive_folder
    }
    Move-Item -Path $report_html_path -Destination $archive_file_path
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
try {
    Set-Content -Path $service_file_path -Value $service_file -ErrorAction Stop
} catch {
    Write-Error "Error writing service file to disk: $_"
    Exit 1
}

# Reload the systemd daemon and start the service
try {
    sudo systemctl daemon-reload
    sudo systemctl restart serverMonitor.service
} catch {
    Write-Error "Error restarting service: $_"
    Exit 1
}

# Verify that the service is running
try {
    $service_status = sudo systemctl status serverMonitor.service
    Write-Host $service_status
} catch {
    Write-Error "Error checking service status: $_"
    Exit 1
}

# Create the initial HTML output with table headers and styling
$html = "<html><head><title>Server Monitoring Report</title><link rel='stylesheet' href='/style.css'></head><body><h1>Server Monitoring Report</h1><table id='reportTable'><tr><th>Date</th><th>Time</th><th>CPU usage</th><th>Memory usage</th><th>Private IP</th><th>Public IP</th></tr>"

# Write the initial HTML output to disk
try {
    Set-Content -Path "/var/www/html/report.html" -Value $html -Encoding utf8
} catch {
    Write-Error "Error writing report.html file to disk: $_"
    Exit 1
}

# Launch the monitoring script
Write-Output "Launching monitoring script..."
$monitoring_script = "/home/monitoring/output.ps1"
try {
    # Start the monitoring script as a background job
    Start-Job -ScriptBlock { & pwsh $using:monitoring_script }
    Write-Output "Monitoring script started"

} catch {
    Write-Error "Error launching monitoring script: $_"
    Exit 1
}
