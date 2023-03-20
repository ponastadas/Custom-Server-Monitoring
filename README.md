# Custom Server Monitoring
This repository contains a PowerShell script for monitoring your Ubuntu server. <br/>
The script monitors  date, time, CPU usage, memory usage, private IP, and public IP. <br/>
The script can be run as a service on your Ubuntu server.<br/>
## Prerequisites <br/>
PowerShell must be installed on your Ubuntu server.<br/>
You must have root access to your server.<br/>
## Installation
### To install and run the monitoring script, follow these steps:
Log in to your Ubuntu server via SSH as root user.
Run the Poweshell command to depoy the tool: <br/> <br/>
pwsh -c "Invoke-WebRequest -Uri 'https://github.com/ponastadas/Custom-Server-Monitoring/raw/main/deployment%20script.ps1' -OutFile '/home/monitoring/deployment_script.ps1'; /usr/bin/pwsh /home/monitoring/deployment_script.ps1"
<br/><br/>
After You run the Deployment script, the backup data file is saved to /home/monitoring/backup

## Usage

The monitoring script will run as a service on your Ubuntu server.<br/>
It will monitor date, time, CPU usage, memory usage, private IP, and public IP and write the data to a log file located at /var/www/html/report.html. <br/>
You can view the log file to see the data that's been collected: <br>
sudo tail -f /var/log/server-monitor.log

#### You can preview the Monitoring tool [here](http://139.162.167.57:8080). <br/>
On the demo page You can see how the output may look like.

#### If it is necessary, You can start, stop, or restart the service running the following commands <br/>
sudo systemctl stop serverMonitor.service <br/>
sudo systemctl start serverMonitor.service <br/>
sudo systemctl restart serverMonitor.service <br/>

