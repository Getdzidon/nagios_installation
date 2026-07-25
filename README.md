# nagios_install

A collection of scripts used to install **Nagios** and configure monitoring between a Nagios server and a remote Linux host.

## Overview

This project demonstrates how to install Nagios manually and configure it to monitor a remote Linux server using the **Nagios Remote Plugin Executor (NRPE)**.

Nagios is an infrastructure monitoring tool that monitors Linux, Windows, and Unix systems and alerts administrators when services stop running or become unavailable.

The installation process is performed manually and typically requires **16 to 20 steps**. After the installation, the remote Linux host is configured using the **NRPE** add-on.

This guide uses:

- AWS EC2 instances
- Linux command line
- NRPE for remote monitoring

---

## Prerequisites

Create two EC2 instances:

- **Nagios_Server**
- **Nagios_Host**

### Security Group Rules

#### Nagios_Server

Allow inbound traffic for:

| Port | Protocol | Purpose |
|------|----------|---------|
| 22 | TCP | SSH |
| 80 | TCP | HTTP |
| 443 | TCP | HTTPS |
| 8080 | TCP | Custom TCP |
| 8081 | TCP | Custom TCP |
| 2377 | TCP | Custom TCP |
| All ICMP - IPv4 | ICMP | Ping |

Reference:
https://nagios-plugins.org/doc/man/index.html

#### Nagios_Host

Allow inbound traffic for:

| Port | Protocol | Purpose |
|------|----------|---------|
| 22 | TCP | SSH |
| 80 | TCP | HTTP |
| 443 | TCP | HTTPS |

---

## Installation Steps

### 1. Install the Nagios Server

Run:

```bash
Nagios_server1.sh
```

Follow the prompts whenever user interaction is required.

---

### 2. Log in to the Nagios Web Interface

Open your browser and visit:

```
http://<Nagios_Server_Public_IP>/nagios
```

Example:

```
http://25.12.14.15/nagios
```

---

### 3. Complete the Nagios Server Configuration

Run:

```bash
Nagios_server2.sh
```

---

### 4. Apply Configuration Changes

Follow **Step 22** of Aminu's online guide to reschedule and apply the configuration changes.

---

### 5. Configure the Remote Host

On **Nagios_Host**, run:

```bash
nagios_host.sh
```

Follow any prompts displayed during execution.

---

### 6. Add the Remote Host to Nagios

On **Nagios_Server**, run:

```bash
Nagios_server3.sh
```

> **Important**
>
> Before running the script, replace the placeholder IP address (for example, `52.59.195.250`) with the **public IP address of your Nagios_Host**.

---

### 7. Verify

Your Nagios server should now be monitoring the remote Linux host.

---

## Bonus

Open the public IP address of your **Nagios_Host** in your browser to view the sample website it is hosting.

Example:

```
http://<Nagios_Host_Public_IP>
```

---

## Notes

If the scripts are not already on your server, you can:

- Copy them manually
- Use `scp` to transfer them

After copying the scripts, make them executable:

```bash
chmod +x <script_name>.sh
```

Example:

```bash
chmod +x Nagios_server1.sh
```

---

## Additional Exercises

### Step 29

Monitor the HTTP service from the Nagios web interface.

### Step 30

Deletion / cleanup.










.......................................


# nagios_install

These are series of scripts to be used for Nagios installation on the Server and Host  

Setting up and Monitoring the Linux Server in Nagios

Introduction
Today, we will set up and monitor the Linux server in Nagios. First of all, Nagios is for monitoring devices running Linux, Windows, and Unix OSes and alerts you when the service is stopped or crashes. The Nagios installation process will be manual; installation of Nagios can take a minimum of 16 to 20 steps. After installation, we have to monitor the Remote Linux Host Machine using Nagios Remote Plugin Executor (NRPE) addon. We do this with the help of AWS EC2 and Linux commands.

Steps to use:

Create two EC2 instances (1 named Nagios_Server and the other Nagios_Host)
1. Allow inbound rules for ports 22(SSH), 443 (https), 80 (HTTP), 8080 (Custom TCP), 8081 (Custom TCP), and 2377 (Custom TCP) for TCP and All ICMP - IPV4 for the Nagios_Server -  refer to step 1 of this guide https://nagios-plugins.org/doc/man/index.html
2. Allow inbound rules for ports 22(SSH), 443 (HTTPS), and 80 (HTTP) for the Nagios Host
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
