#!/bin/bash

#ref: https://medium.com/@princeashok069/nagios-practical-028bd64c5c88
# On the NAGIOS SERVER 

# Step 24: Add Host to Nagios Configuration in NAGIOS SERVER

# Note: Replace <nagios-host-public-ip> with the actual Public IP addresses of your NAGIOS HOST

sudo bash -c 'cat > /usr/local/nagios/etc/servers/nagihost.cfg <<EOL

#################
# define a hosts 
#################

define host {
    use         linux-server
    host_name   nagios-host-01
    alias       Linux host 01
    address     63.177.107.39
}

define host {
    use         linux-server
    host_name   nagios-host-02
    alias       Linux host 02
    address     3.72.247.138
}

define host {
    use         linux-server
    host_name   nagios-host-03
    alias       Linux host 03
    address     3.73.85.72
}

##########################################
# define a hostgroup for the linux hosts
##########################################

define hostgroup {
    hostgroup_name  linux-hosts-for-nagios-monitoring
    alias           Linux hosts
    members         nagios-host-01,nagios-host-02,nagios-host-03
}

#########################
#SERVICES
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
# on the local machine.  Warning if < 20% free, critical if
# < 10% free space on partition.

define service {
    use                     generic-service
    hostgroup_name          linux-hosts-for-nagios-monitoring
    service_description     Root Partition
    check_command           check_nrpe!check_local_disk
}


# Define a service to check the number of currently logged in
# users on the local machine.  Warning if > 20 users, critical
# if > 50 users.

define service {
    use                     generic-service
    hostgroup_name          linux-hosts-for-nagios-monitoring
    service_description     Current Users
    check_command           check_nrpe!check_local_users
}

# Define a service to check the number of currently running procs
# on the local machine.  Warning if > 250 processes, critical if
# > 400 processes.

define service {
    use                     generic-service
    hostgroup_name          linux-hosts-for-nagios-monitoring
    service_description     Total Processes
    check_command           check_nrpe!check_local_procs
}


# Define a service to check the load on the local machine.

define service {
    use                     generic-service
    hostgroup_name          linux-hosts-for-nagios-monitoring
    service_description     Current Load
    check_command           check_nrpe!check_local_load
}

EOL'
sudo systemctl restart nagios.service #to restart Nagios server

# Step 25 — Monitor the newly added host in the Nagios Website

# 1. Go to the Nagios Website, refresh and click on Hosts.
# 2. newly added host “nagihost” is added and the status is also up.
# 3. Click on it and monitor its services if there are any

#Steps 26 and 27 done on the HOST

# Step 28: Add HTTP Service to nagihost.cfg File in Nagios Server (DEFINED BY SECOND BLOCK ABOVE "define service")

# Step 29 — Monitor the HTTP service in the Nagios Website
# 1. Go to the Nagios Website and click on Services.
# 2. The HTTP service for “nagihost” is added and the status is OK.
# 3. if the status shows critical or pending we can click on that pending server
# 4. it takes us to server state information in that we can click on reschedule at servers commands
# 5. then we will get into command options there we have to click on commit
# 6. later click on done


# Step 30: Deletion (Optional)
# You can terminate the Nagios and remote host instances if desired.

echo "Nagios setup and monitoring configuration complete. Please verify the setup by visiting the Nagios web interface."
