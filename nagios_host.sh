# #!/bin/bash 

set -e

NAGIOS_SERVER_IP="3.121.184.181"

#ref: https://medium.com/@princeashok069/nagios-practical-028bd64c5c88

# On the MONITORED HOST | Install and configure NRPE

# update and upgrade the system packages
sudo apt update 
sudo apt upgrade -y

# Step 23: Download, Extract and Install NRPE Script in Remote Linux Host Machine

# 1. open the AWS EC2 service and Launch an instance with the name Nagios-host-linux.
# 2. Configure the AWS Security Group:
#    - SSH (22) from your administration IP
#    - HTTP (80) as required
#    - HTTPS (443) as required
#    - NRPE (5666) from the Nagios server only
# 3. Now connect to the super putty.
# 4. Now we have to Download, extract and Install NRPE Script
# 5. same as like above process change the directory “cd” to /opt
# 6. Install “linux-nrpe-agent.tar.gz” by using “wget” command
# 7. Now extract the “linux-nrpe-agent” by using “tar” command.
# 8. Again change the directory to “ linux-nrpe-agent”
# 9. Now run the command sudo ./fullinstall, while running it may ask permission then type “y” at the last you will get like this
# *****10. Now copy the hostname/Public IP of the Nigos Server with help of this command you see the hostname “hostname -i”.
# 11. paste that copied hostname to nagios-host-linux at allow from

cd /opt
sudo wget http://assets.nagios.com/downloads/nagiosxi/agents/linux-nrpe-agent.tar.gz
sudo tar xzf linux-nrpe-agent.tar.gz
cd linux-nrpe-agent
sudo ./fullinstall


# step 24 and 25 is done on the NAGIOS SERVER

# Step 26: Install Apache2 Web Server in Remote Linux Host Machine
sudo apt-get install apache2 -y
sudo systemctl start apache2

# Step 27: Deploy Custom Webpage in Apache Web Server
cd /var/www/html
sudo rm index.html
sudo bash -c 'cat > index.html <<EOL
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Server 1 Card</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #F4F4F4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .card {
            background-color: #FFFFFF;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 300px;
            padding: 20px;
            text-align: center;
        }
        .card h2 {
            margin: 0 0 15px;
            color: #333333;
        }
        .card p {
            color: #777777;
            margin: 0 0 15px;
        }
        .card .status {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            background-color: #28A745;
            color: white;
            font-weight: bold;
        }
        .card .status.down {
            background-color: #DC3545;
        }
    </style>
</head>
<body>
    <div class="card">
        <h2>Hey there!</h2>
        <p>Welcome!</p>
        <p>This is a Test Webpage on Nagios-Host-01</p>
        <p>By FirstByte Trainees</p>
        <p class="status">Online</p>
    </div>
</body>
</html>
EOL'


# Configure firewall
sudo ufw allow OpenSSH
sudo ufw allow Apache
sudo ufw allow 'Apache Secure'
sudo ufw allow from "$NAGIOS_SERVER_IP" to any port 5666 proto tcp
sudo ufw enable
sudo ufw reload