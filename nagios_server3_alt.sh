#!/bin/bash

set -e

# Nagios monitored host IP addresses
NAGIOS_HOST_01_IP="3.73.85.128"
NAGIOS_HOST_02_IP="18.194.99.126"
NAGIOS_HOST_03_IP="3.73.85.72"

#ref: https://medium.com/@princeashok069/nagios-practical-028bd64c5c88
# On the NAGIOS SERVER 

# Step 24: Add Host to Nagios Configuration in NAGIOS SERVER

# Note: Replace <nagios-host-public-ip> with the actual Public IP addresses of your NAGIOS HOST


############################################################
# Configure check_nrpe command
############################################################

# The default check_nrpe command only passes $ARG1$.
# Our NRPE commands such as check_disk, check_users and
# check_load require additional arguments, so $ARG2$ must
# also be passed to the remote NRPE client.

sudo sed -i '/^[[:space:]]*command_name[[:space:]]*check_nrpe[[:space:]]*$/{n;s|.*command_line.*|     command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$ -a "$ARG2$"|;}' \
    /usr/local/nagios/etc/objects/commands.cfg


############################################################
# Add hosts and services to Nagios configuration
############################################################

sudo tee /usr/local/nagios/etc/servers/nagios-hosts.cfg > /dev/null <<EOL

#################
# Define hosts  
#################

define host {
    use         linux-server
    host_name   nagios-host-01
    alias       Linux host 01
    address     ${NAGIOS_HOST_01_IP}
}

define host {
    use         linux-server
    host_name   nagios-host-02
    alias       Linux host 02
    address     ${NAGIOS_HOST_02_IP}
}

define host {
    use         linux-server
    host_name   nagios-host-03
    alias       Linux host 03
    address     ${NAGIOS_HOST_03_IP}
}

##########################################
# Define a HostGroup for the linux hosts
##########################################

define hostgroup {
    hostgroup_name  linux-hosts-for-nagios-monitoring
    alias           Linux hosts
    members         nagios-host-01,nagios-host-02,nagios-host-03
}

#########################
# SERVICES
#########################

# Define a service to check HTTP on the local machine.
# Disable notifications for this service by default, as not all users may have HTTP enabled.

define service {
    use                     generic-service
    hostgroup_name          linux-hosts-for-nagios-monitoring
    service_description     HTTP
    check_command           check_http
}


# Define a service to "ping" the local machine

define service {

    use                     generic-service           ; Name of service template to use
    hostgroup_name          linux-hosts-for-nagios-monitoring
    service_description     PING
    check_command           check_ping!100.0,20%!500.0,60%
}


# Define a service to check the disk space of the root partition
# on the local machine.  Warning if < 20% free, critical if < 10% free space on partition.

define service {
    use                     generic-service
    hostgroup_name          linux-hosts-for-nagios-monitoring
    service_description     Root Partition
    check_command           check_nrpe!check_disk!-w 20% -c 10% -p /
}


# Define a service to check the number of currently logged in
# users on the local machine.  Warning if > 5 users, critical if > 10 users.

define service {
    use                     generic-service
    hostgroup_name          linux-hosts-for-nagios-monitoring
    service_description     Current Users
    check_command           check_nrpe!check_users!-w 5 -c 10
}


# Define a service to check the number of currently running procs
# on the local machine.  This command reports the current number of running processes.

define service {
    use                     generic-service
    hostgroup_name          linux-hosts-for-nagios-monitoring
    service_description     Total Processes
    check_command           check_nrpe!check_procs
}


# Define a service to check the load on the local machine.

define service {
    use                     generic-service
    hostgroup_name          linux-hosts-for-nagios-monitoring
    service_description     Current Load
    check_command           check_nrpe!check_load!-w 5.0,4.0,3.0 -c 10.0,8.0,6.0
}

EOL


############################################################
# Validate configuration before restarting Nagios
############################################################

echo
echo "=============================================="
echo "Validating Nagios configuration..."
echo "=============================================="

if sudo /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg; then

    echo
    echo "Nagios configuration is valid."
    echo "Restarting Nagios..."

    sudo systemctl restart nagios.service

    echo
    echo "Nagios restarted successfully."

else

    echo
    echo "ERROR: Nagios configuration validation failed."
    echo "Nagios was NOT restarted."
    exit 1

fi


# Step 25 — Monitor the newly added host in the Nagios Website

# 1. Go to the Nagios Website, refresh and click on Hosts.
# 2. All hosts in the "linux-hosts-for-nagios-monitoring" HostGroup will be added and there status will also up.
# 3. Click on the hosts and monitor its services if there are any

# Steps 26 and 27 done on the HOST

# Step 28: Add HTTP Service to nagios-hosts.cfg File on Nagios Server (Defines under services "define service")

# Step 29 — Monitor the HTTP service in the Nagios Website
# 1. Go to the Nagios Website and click on Services.
# 2. The HTTP service for all hosts in the "linux-hosts-for-nagios-monitoring" HostGroup will be added and the status should be OK.
# 3. if the status shows critical or pending we can click on that pending server
# 4. it takes us to server state information in that we can click on reschedule at servers commands
# 5. then we will get into command options there we have to click on commit
# 6. later click on done


# Step 30: Deletion (Optional)
# You can terminate the Nagios and remote host instances if desired.

echo
echo "=============================================="
echo "Nagios setup and monitoring configuration complete."
echo "Please verify the setup by visiting the Nagios web interface."
echo "=============================================="