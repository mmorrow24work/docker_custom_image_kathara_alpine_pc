
# dockerfile used to create the custom docker image used with kathara - alpine_pc

Mick Morrow  | Solutions Architect
Email: Mick.Morrow@telent.com
Mobile: 07974398922
Web: www.telent.com

I created this dockerfile for the customer docker image I use for my digital twin kathara lab.conf - see extract below :

```bash
WSL-Ubuntu 24.04.1 LTS:$ cat lab.conf
LAB_DESCRIPTION="Network Configuration Scenario – IS#33B"
LAB_VERSION=1.0
LAB_AUTHOR="Mick Morrow _ Solutions Architect"
LAB_EMAIL=Mick.Morrow@telent.com
LAB_WEB=https://telent.com/

snmp_manager[0]="sms"
snmp_manager[bridged]="true"
snmp_manager[image]="zabbix7.4-ubuntu24"
snmp_manager[port]="8080:80/tcp"
snmp_manager[port]="10051:10051/tcp"
snmp_manager[port]="10050:10050/tcp"

netflowcollector[0]="sms"
netflowcollector[image]="alpine_pc"

pc1[0]="sms"
pc1[image]="alpine_pc"

pc2[0]="24"
pc2[image]="alpine_pc"

WSL-Ubuntu 24.04.1 LTS:$
```

***

* Install required packages
* Configure SNMPD: minimal snmpd.conf with trap target and community "public"
* Configure Zabbix Agent: update Server and Hostname for flexibility
* Expose SNMP (161/udp), Zabbix agent port (10050/tcp), softflowd (2055/udp)
* Start all required services and keep container running
