function Initialize-ReportHtml {
    return @"
<html><head><title>Server Monitoring Report</title><meta http-equiv='refresh' content='10'><style>
h1{
    margin:20px;
}
table {
    border-collapse: collapse;
    margin: 20px;
    font-size: 16px;
    width: 90%;
    text-align: center;
}
th, td {
    padding: 10px;
    width: 150px;
}
th {
    background-color: #4CAF50;
    color: white;
}
tr:nth-child(odd) {
    background-color: #f2f2f2;
}
tr:nth-child(even) {
    background-color: white;
}
</style>
</head>
<body><h1>Server Monitoring Report</h1><table id='reportTable'><tr><th>Date</th><th>Time</th><th>CPU usage</th><th>Memory usage</th><th>Private IP</th><th>Public IP</th></tr>
"@
}
  
  # Initialize report.html file
  $table = Initialize-ReportHtml
  $table | Out-File -FilePath /var/www/html/report.html -Encoding utf8
  
  # Get last minute
  #$lastMinute = Get-Date -Format "mm"
  # Get the current day value
    $lastDay = Get-Date -Format "dd"
  # Loop to monitor server data
  while ($true) {
    # Get the date and time
    $date = Get-Date -Format "yyyy-MM-dd"
    $time = Get-Date -Format "HH:mm:ss"
  
    # Get the CPU usage
    $cpu_usage = ps -aux --no-headers | awk '{s += $3} END {print s}'
  
    # Get the memory usage
    $mem_usage = ps -aux --no-headers | awk '{s += $4} END {print s}'
  
    # Get the private IP address
    $private_ip = [System.Net.Dns]::GetHostAddresses($(hostname)) | Where-Object { $_.AddressFamily -eq 'InterNetwork' } | Select-Object -ExpandProperty IPAddressToString
    $private_ip = ($private_ip -split " ")[2]
  
    # Get the public IP address
    $public_ip = (Invoke-WebRequest -Uri 'https://api.ipify.org?format=text').Content
  
    # Check if the date has changed and move the report.html file to the archive folder
    $currentDay = Get-Date -Format "dd"
    if ($currentDay -ne $lastDay) {
      $archiveFolder = "/home/monitoring/archive"
      if (!(Test-Path -Path $archiveFolder -PathType Container)) {
        New-Item -ItemType Directory -Path $archiveFolder
      }
      $timestamp = "{0:yyyy-MM-dd_HH-mm-ss}" -f (Get-Date)
      $archiveFilePath = "$archiveFolder/report_$timestamp.html"
      Move-Item -Path /var/www/html/report.html -Destination $archiveFilePath
      $lastDay = $currentDay

      # Initialize a new report.html file in /var/www/html folder without any previous information
      $table = Initialize-ReportHtml
      $table | Out-File -FilePath /var/www/html/report.html -Encoding utf8
    }
  
    # Add the data to the existing HTML table
    $tableData = "<tr><td>$date</td><td>$time</td><td>$cpu_usage %</td><td>$mem_usage %</td><td>$private_ip</td><td>$public_ip</td></tr>"

    # Get the content of the existing report.html file
    $existingContent = Get-Content -Path /var/www/html/report.html -Raw

    # Split the content by the closing table tag
    $contentParts = $existingContent -split "</table>"

    # Add the table data to the first part and then join the parts with the closing table tag
    $newContent = $contentParts[0] + $tableData + "</table>" + $contentParts[1]

    # Write the updated content back to the report.html file
    Set-Content -Path /var/www/html/report.html -Value $newContent -Force
    Write-Output "Added new record"

  
    # Delete files older than 10 days
    $archiveFolder = "/home/monitoring/archive"
    $limit = (Get-Date).AddDays(-10)
    Get-ChildItem -Path $archiveFolder -Recurse | Where-Object { !$_.PSIsContainer -and $_.LastWriteTime -lt $limit } | Remove-Item -Force
    Write-Output "Files older than 10 days were removed"
  
    # Wait for 10 seconds before checking the usage again
    Start-Sleep -Seconds 10
  }
