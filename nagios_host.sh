# #!/bin/bash 

set -e

NAGIOS_SERVER_IP="52.29.161.98"

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


# Install NRPE
cd /opt
sudo wget http://assets.nagios.com/downloads/nagiosxi/agents/linux-nrpe-agent.tar.gz
sudo tar xzf linux-nrpe-agent.tar.gz
cd linux-nrpe-agent
sudo ./fullinstall

############################################################
# Configure custom logged-in users check
############################################################

sudo tee /usr/local/nagios/libexec/check_active_users > /dev/null <<'EOF'
#!/bin/bash

USERS=$(loginctl list-sessions --no-legend | awk '$6=="user"{print $3}' | sort -u)
COUNT=$(echo "$USERS" | sed '/^$/d' | wc -l)

if [ "$COUNT" -gt 10 ]; then
    echo "USERS CRITICAL - $COUNT users currently logged in"
    exit 2
elif [ "$COUNT" -gt 5 ]; then
    echo "USERS WARNING - $COUNT users currently logged in"
    exit 1
else
    echo "USERS OK - $COUNT users currently logged in"
    exit 0
fi
EOF

sudo chmod +x /usr/local/nagios/libexec/check_active_users

sudo tee /usr/local/nagios/etc/nrpe/check_active_users.cfg > /dev/null <<'EOF'
command[check_active_users]=/usr/local/nagios/libexec/check_active_users
EOF

sudo systemctl restart xinetd


# step 24 and 25 is done on the NAGIOS SERVER

############################################################
# Install Apache
############################################################
# Step 26: Install Apache2 Web Server in Remote Linux Host Machine
sudo apt-get install apache2 -y
sudo systemctl start apache2


############################################################
# Deploy custom webpage
############################################################
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


############################################################
# Configure firewall
############################################################
sudo ufw allow OpenSSH
sudo ufw allow Apache
sudo ufw allow 'Apache Secure'
sudo ufw allow from "$NAGIOS_SERVER_IP" to any port 5666 proto tcp

sudo ufw enable
sudo ufw reload


############################################################
# Verify custom user check
############################################################

echo
echo "Testing active users check:"
sudo /usr/local/nagios/libexec/check_active_users

echo
echo "NRPE configuration:"
sudo grep "check_active_users" /usr/local/nagios/etc/nrpe/check_active_users.cfg

echo
echo "Host configuration complete."