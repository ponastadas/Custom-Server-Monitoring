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

## Apache installation guide:
Update the package list by running the following command: <br/>
sudo apt update <br/>
Install the Apache web server using the following command:<br/>
sudo apt install apache2<br/>
Once the installation is complete, start the Apache service by running the following command:<br/>
sudo systemctl start apache2<br/>
Check the status of the Apache service by running the following command:<br/>
sudo systemctl status apache2<br/>
By default, Apache listens on port 80. To change the default port to 8080, open the Apache configuration file using the following command:<br/>
sudo nano /etc/apache2/ports.conf<br/>
Replace the following line with 'Listen 8080'<br/>
Listen 80<br/>
Save the changes and exit the text editor.<br/>
Restart the Apache service for the changes to take effect:<br/>
sudo systemctl restart apache2<br/>
Check if Apache is listening on port 8080 by running the following command:<br/>
sudo netstat -tuln | grep 8080<br/>
If you want to allow incoming traffic on port 8080 (which Apache is now listening on) through the firewall, you can use the following commands:<br>
sudo ufw allow 8080/tcp <br/>
Verify the rule has been added by running:<br/>
sudo ufw status <br/>
You should see a message like "8080/tcp ALLOW Anywhere"




