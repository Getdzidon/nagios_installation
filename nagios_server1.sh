#!/bin/bash

# Open Ports 8080, 8081 and 2377 for TCP
# ON THE NAGIOS SERVER
# ref: https://medium.com/@princeashok069/nagios-practical-028bd64c5c88

# Steps 2 to 16. Be sure to run the rest of the commands manually after this
# The steps from 17 onward typically involve post-installation tasks, such as fixing specific issues, adding hosts, and setting up monitoring for remote machines, which might be seen as extensions rather than core parts of the installation.

# Step2 - Update and install prerequisite tools
sudo apt update 
sudo apt upgrade -y
sudo apt install autoconf gcc libc6 make wget unzip apache2 apache2-utils php libgd-dev libmcrypt-dev libssl-dev bc gawk dc build-essential snmp libnet-snmp-perl gettext
sudo apt-get install -y openssl libssl-dev

# Step3 - Move index.php to the first position in Apache dir.conf and restart Apache
sudo sed -i 's/DirectoryIndex.*/DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm/' /etc/apache2/mods-enabled/dir.conf
sudo systemctl restart apache2

# Sep 4 - Download, extract, compile, and install Nagios Core
cd /opt
sudo wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.14.tar.gz
sudo tar xzf nagioscore.tar.gz
cd nagioscore-nagios-4.4.14/
sudo ./configure --with-httpd-conf=/etc/apache2/sites-enabled
sudo make all

# Step 5 - Create user and group for Nagios
sudo make install-groups-users
sudo usermod -a -G nagios www-data

# Step 6 - Install binaries, service/daemon, command mode, configuration files, and Apache config file
sudo make install
sudo make install-daemoninit
sudo make install-commandmode
sudo make install-config
sudo make install-webconf

# Step 7 - Configure Nagios
sudo mkdir /usr/local/nagios/etc/servers
sudo sed -i 's|#cfg_dir=/usr/local/nagios/etc/servers|cfg_dir=/usr/local/nagios/etc/servers|' /usr/local/nagios/etc/nagios.cfg

# Step 8 - Configure Nagios contacts
sudo sed -i 's/nagios@localhost/your-email@example.com/' /usr/local/nagios/etc/objects/contacts.cfg

# Step 9 - Configure check_nrpe command
sudo bash -c 'cat <<EOF >> /usr/local/nagios/etc/objects/commands.cfg
define command{
     command_name check_nrpe
     command_line \$USER1\$/check_nrpe -H \$HOSTADDRESS\$ -c \$ARG1\$
}
EOF'

# Step 10 - Configure Apache
sudo a2enmod rewrite
sudo a2enmod cgi

# Step 11 - Configure the firewall
sudo ufw allow OpenSSH # Note : This command allows SSH connections through the firewall, which is essential for remote access to the server. You may need to adjust this command based on your specific firewall configuration and security requirements.
sudo ufw allow Apache
sudo ufw allow 'Apache Secure'
sudo ufw allow 8080/tcp
sudo ufw allow 8081/tcp
sudo ufw allow 2377/tcp
sudo ufw enable
sudo ufw reload

# Step 12 - Configure Nagios service
sudo bash -c 'cat <<EOF > /etc/systemd/system/nagios.service
[Unit]
Description=Nagios
BindTo=network.target
[Install]
WantedBy=multi-user.target
[Service]
Type=simple
User=nagios
Group=nagios
ExecStart=/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
EOF'

# Step 13 - Set Nagios admin user password
sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

# Step 14 - Restart Apache and start Nagios service
sudo systemctl restart apache2.service

# Step 15 - Install Nagios plugins dependencies
sudo apt-get install -y autoconf gcc libc6 libmcrypt-dev make libssl-dev wget bc gawk dc build-essential snmp libnet-snmp-perl gettext

# Step 16 - Download, extract, compile, and install the Nagios plugins package
cd /opt
sudo wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.4.6.tar.gz
sudo tar xzf nagios-plugins.tar.gz
cd nagios-plugins-release-2.4.6/
sudo ./tools/setup
sudo ./configure
sudo make
sudo make install

# Step 17 - Install NRPE plugin
sudo apt install -y nagios-nrpe-plugin

# Make check_nrpe available to Nagios Core
sudo ln -sf /usr/lib/nagios/plugins/check_nrpe \
    /usr/local/nagios/libexec/check_nrpe

# Verify
ls -l /usr/local/nagios/libexec/check_nrpe

# Validate Nagios configuration
sudo /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

# Final restart of Nagios service
sudo systemctl restart nagios.service


# Final message
echo "Nagios installation and basic configuration completed. Access the Nagios web interface to continue."