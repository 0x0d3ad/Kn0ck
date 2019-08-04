## ABOUT:
Kn0ck is an automated scanner that can be used during a penetration testing to enumerate and scan for vulnerabilities.

## KN0CK COMMUNITY FEATURES:
- [x] Automatically collects basic recon
- [x] Automatically launches Google hacking queries against a target domain
- [x] Automatically enumerates open ports via NMap port scanning
- [x] Automatically brute forces sub-domains, gathers DNS info and checks for zone transfers
- [x] Automatically checks for sub-domain hijacking
- [x] Automatically runs targeted NMap scripts against open ports
- [x] Automatically runs targeted Metasploit scan and exploit modules
- [x] Automatically scans all web applications for common vulnerabilities
- [x] Automatically brute forces ALL open services
- [x] Automatically test for anonymous FTP access
- [x] Automatically runs WPScan, Arachni and Nikto for all web services
- [x] Automatically enumerates NFS shares
- [x] Automatically test for anonymous LDAP access
- [x] Automatically enumerate SSL/TLS ciphers, protocols and vulnerabilities
- [x] Automatically enumerate SNMP community strings, services and users
- [x] Automatically list SMB users and shares, check for NULL sessions and exploit MS08-067
- [x] Automatically exploit vulnerable JBoss, Java RMI and Tomcat servers
- [x] Automatically tests for open X11 servers
- [x] Auto-pwn added for Metasploitable, ShellShock, MS08-067, Default Tomcat Creds
- [x] Performs high level enumeration of multiple hosts and subnets
- [x] Automatically integrates with Metasploit Pro, MSFConsole and Zenmap for reporting
- [x] Automatically gathers screenshots of all web sites
- [x] Create individual workspaces to store all scan output

## AUTO-PWN:
- [x] Apache Struts CVE-2018-11776 RCE exploit
- [x] Android Insecure ADB RCE auto exploit
- [x] Apache Tomcat CVE-2017-12617 RCE exploit
- [x] Oracle WebLogic WLS-WSAT Component Deserialisation RCE CVE-2017-10271 exploit
- [x] Drupal Drupalgedon2 RCE CVE-2018-7600
- [x] GPON Router RCE CVE-2018-10561
- [x] Apache Struts 2 RCE CVE-2017-5638
- [x] Apache Struts 2 RCE CVE-2017-9805
- [x] Apache Jakarta RCE CVE-2017-5638
- [x] Shellshock GNU Bash RCE CVE-2014-6271
- [x] HeartBleed OpenSSL Detection CVE-2014-0160
- [x] Default Apache Tomcat Creds CVE-2009-3843
- [x] MS Windows SMB RCE MS08-067
- [x] Webmin File Disclosure CVE-2006-3392
- [x] Anonymous FTP Access
- [x] PHPMyAdmin Backdoor RCE
- [x] PHPMyAdmin Auth Bypass
- [x] JBoss Java De-Serialization RCEs

## ACTIVED YOUR API-KEY & SECRET-KEY ACCOUNT CENSYS:
```
->  knock.conf
	CENSYS_APP_ID="REDACTED"
	CENSYS_API_SECRET="REDACTED"
```

## KALI LINUX INSTALL:
```
chmod +x install.sh
./install.sh
```

## DEBIAN OR UBUNTU INSTALL:
```
chmod +x install_for_debian_ubuntu.sh
./install_for_debian_ubuntu.sh
```

## USAGE:
```
[*] NORMAL MODE
knock -t <TARGET>

[*] NORMAL MODE + OSINT + RECON
knock -t <TARGET> | -o (Osint) | -re (Recon)

[*] STEALTH MODE + OSINT + RECON
knock -t <TARGET> | -m stealth | -o (Osint) | -re (Recon)

[*] DISCOVER MODE
knock -t <Target> | -m discover | -w <WORSPACE_ALIAS>

[*] SCAN ONLY SPECIFIC PORT
knock -t <TARGET> | -m port | -p <portnum>

[*] FULLPORTONLY SCAN MODE
knock -t <TARGET> | -fp (Fullportonly)

[*] PORT SCAN MODE
knock -t <TARGET> | -m port -p <PORT_NUM>

[*] WEB MODE - PORT 80 + 443 ONLY!
knock -t <TARGET> | -m web

[*] HTTP WEB PORT MODE
knock -t <TARGET> | -m webporthttp | -p <port>

[*] HTTPS WEB PORT MODE
knock -t <TARGET> | -m webporthttps | -p <port>

[*] ENABLE BRUTEFORCE
knock -t <TARGET> | -b (Bruteforce)

[*] LIST WORKSPACES
knock --list

[*] DELETE WORKSPACE
knock -w <WORKSPACE_ALIAS> -d

[*] DELETE HOST FROM WORKSPACE
knock -w <WORKSPACE_ALIAS> -t <TARGET> -dh

[*] GET knock SCAN STATUS
knock --status

[*] LOOT REIMPORT FUNCTION
knock -w <WORKSPACE_ALIAS> --reimport
```

### MODE:
* **NORMAL:** Performs basic scan of targets and open ports using both active and passive checks for optimal performance.
* **STEALTH:** Quickly enumerate single targets using mostly non-intrusive scans to avoid WAF/IPS blocking.
* **AIRSTRIKE:** Quickly enumerates open ports/services on multiple hosts and performs basic fingerprinting. To use, specify the full location of the file which contains all hosts, IPs that need to be scanned and run ./knock /full/path/to/targets.txt airstrike to begin scanning.
* **DISCOVER:** Parses all hosts on a subnet/CIDR (ie. 192.168.0.0/16) and initiates a knock scan against each host. Useful for internal network scans.
* **PORT:** Scans a specific port for vulnerabilities. Reporting is not currently available in this mode.
* **FULLPORTONLY:** Performs a full detailed port scan and saves results to XML.
* **WEB:** Adds full automatic web application scans to the results (port 80/tcp & 443/tcp only). Ideal for web applications but may increase scan time significantly.   
* **WEBPORTHTTP:** Launches a full HTTP web application scan against a specific host and port.
* **WEBPORTHTTPS:** Launches a full HTTPS web application scan against a specific host and port.