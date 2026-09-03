#!/bin/bash

# This script is doing two main things on the Nagios server: 
# It creates a 1 GB swap file to fix the Nagios "Swap usage" critical alert.
# It provides instructions for accessing the Nagios web interface and manually rescheduling the check.

#ref: https://medium.com/@princeashok069/nagios-practical-028bd64c5c88
# ON THE NAGIOS SERVER

# Step 17: Open Nagios Server Website 

# 1. To open the Nagios Server website we need to go back to the AWS EC2 instances page.
# 2. select the Nagios server and get the public IP address and copy it
# 3. paste the public IP address in the new tab and after the IP address give the tag as “/nagios”
# Note: <your-nagios-server-public-ip>/nagios 

# 4. Give the username and password we set
# 5. Go to the Hosts section and you will notice there will be a hosts “localhost” and its status will be up
# 6. Now go to the Service section and you will notice there will be an error for “Swap usage” with status critical
# 7. This error is because in the Nagios Server instance there is no swap partition.

# Step 18: Fixing Swap Usage Error 
sudo dd if=/dev/zero of=/root/myswapfile bs=1M count=1024

# Step 19: Check and change the permission for the file
sudo ls -lh /root/myswapfile
sudo chmod 600 /root/myswapfile

# Step 20: Make this file as a swap file using mkswap command
sudo mkswap /root/myswapfile

# Step 21: Enable the newly created swapfile
sudo swapon /root/myswapfile

# Step 22: Reschedule the Service to Update Changes

# This is a manual step to be performed in the Nagios web interface.
# Now, go back to the Services section in Nagios website.
# Click on "Swap usage" service and click on “Re-schedule the next check” under the Service Commands menu and click "commit", then "Done"

# Monitor Remote Linux Host Machine using NRPE addon
