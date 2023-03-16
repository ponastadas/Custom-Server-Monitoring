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
Run the [deployment script](https://raw.githubusercontent.com/ponastadas/Custom-Server-Monitoring/main/deployment%20script.ps1):

## Usage

The monitoring script will run as a service on your Ubuntu server.<br/>
It will monitor date, time, CPU usage, memory usage, private IP, and public IP and write the data to a log file located at /var/www/html/report.html. <br/>
You can view the log file to see the data that's been collected: <br>
sudo tail -f /var/log/server-monitor.log

#### You can preview the Monitoring tool [here](http://139.162.167.57:8080). <br/>

#### If it is necessary, You can start, stop, or restart the service running the following commands <br/>
sudo systemctl stop serverMonitor.service <br/>
sudo systemctl start serverMonitor.service <br/>
sudo systemctl restart serverMonitor.service <br/>


