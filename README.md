# nagios_install

These are series of scripts to be used for Nagios installation on the Server and Host  

Setting up and Monitoring the Linux Server in Nagios

Introduction
Today we will set up and monitor the Linux server in Nagios. First of all, Nagios is for monitoring devices running Linux, Windows, and Unix OSes and alerts you when the service is stopped or crashes. The Nagios installation process will be manual, installation of Nagios can take a minimum of 16 to 20 steps after installation we have to Monitor the Remote Linux Host Machine using Nagios Remote Plugin Executor (NRPE) addon we do this with the help of AWS EC2 and Linux commands.

Steps to use:

Create two EC2 instances (1 named Nagios_Server and the other Nagios_Host)
1. Allow inbound rules for ports 22(SSH), 443 (https), 80 (HTTP), 8080 (Custom TCP), 8081 (Custom TCP), and 2377 (Custom TCP) for TCP and All ICMP - IPV4 for the Nagios_Server -  refer to step 1 of this guide https://nagios-plugins.org/doc/man/index.html
2. Allow inbound rules for ports 22(SSH), 443 (HTTPS), and 80 (http) for the Nagios Host
3. Run the FIRST script (Nagios_server1.sh) on the Nagios_Server and interact where needed
4. Sign in to nagios using <your-nagios-server-public-ip>/nagios eg: 25.12.14.15/nagios
5. Run the SECOND script (Nagios_server2.sh) on the Nagios Server
6. Follow step 22 of Aminu's online guide to reschedule the changes to update the changes
7. Run the THIRD script (nagios_host.sh) on the Nagios_Host and interact where needed
8. Run the FOUTH script (Nagios_server3.sh) on the Nagios_Server - (Note: In this script, you need to replace the IP (in this case 52.59.195.250) with the PUBLIC IP of your Nagios_Host

Done

Bonus, you can paste the public IP of your Nagios Host in your browser to see the nice website it is hosting!
Note, you may need to manually copy the scripts to your server, then run chmod +x <name of the script> to make it executable or use the SCP command to copy it to your servers

Step 29— Monitor the HTTP service in the Nagios Website

Step 30— deletion
