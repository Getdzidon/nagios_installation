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
Change name - sudo hostnamectl set-hostname nagios-server

- **Nagios-Host**
Change name to - sudo hostnamectl set-hostname nagios-host

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

### 2. Log in to the Nagios Web Interface using nagiosadmin (set in nagios_server1.sh line 77) and password you set at script runtime

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

Follow **Step 22** of this guide (https://medium.com/@princeashok069/nagios-practical-028bd64c5c88) to reschedule and apply the configuration changes.

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


