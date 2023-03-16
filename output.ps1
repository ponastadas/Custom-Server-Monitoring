# Create the initial HTML output with table headers
$html = "<html><head><title>Server Monitoring Report</title><style>
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
  </style></head><body><h1>Server Monitoring Report</h1><table id='reportTable'> <script>
      // Function to get the server monitoring report data from the server and update the table
      function updateReport() {
        fetch('/report.html') // Get the report.html file from the server
          .then(response => response.text()) // Convert the response to text
          .then(html => {
            // Use a temporary DOM element to extract the table rows from the HTML
            const tempDiv = document.createElement('div');
            tempDiv.innerHTML = html;
            const rows = tempDiv.querySelector('#reportTable').rows;

            // Remove the existing rows from the table
            const table = document.getElementById('reportTable');
            while (table.rows.length > 1) {
              table.deleteRow(1);
            }

            // Add the new rows to the table
            for (let i = 1; i < rows.length; i++) {
              table.insertRow(i).innerHTML = rows[i].innerHTML;
            }
          });
      }

      // Call the updateReport function every 10 seconds to update the table
      setInterval(updateReport, 10000);
    </script><tr><th>Date</th><th>Time</th><th>CPU usage</th><th>Memory usage</th><th>Private IP</th><th>Public IP</th></tr>"
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
    #$private_ip = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias Ethernet0).IPAddress
    $private_ip = [System.Net.Dns]::GetHostAddresses($(hostname)) | Where-Object { $_.AddressFamily -eq 'InterNetwork' } | Select-Object -ExpandProperty IPAddressToString
    $private_ip = ($private_ip -split " ")[2]
   
    # Get the public IP address
    $public_ip = (Invoke-WebRequest -Uri 'https://api.ipify.org?format=text').Content

    # Add the data to the HTML table
    $html += "<tr><td>$date</td><td>$time</td><td>$cpu_usage%</td><td>$mem_usage%</td><td>$private_ip</td><td>$public_ip</td></tr>"

    # Append the output to the existing report.html file
    $html | Out-File -FilePath /var/www/html/report.html -Encoding utf8

    # Wait for 10 seconds before checking the usage again
    Start-Sleep -Seconds 10
}

# Overwrite the existing report.html file with the updated HTML
$html | Out-File -FilePath /var/www/html/report.html -Encoding utf8 -Force